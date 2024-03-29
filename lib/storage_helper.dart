import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rfr_cookbook/models/stored_item.dart';

class StorageHelper {
  static final FirebaseStorage _storageInstance = FirebaseStorage.instance;
  static const _rootDir = 'protocols';
  static Map<String, List<StoredItem>> _localStorageMap = {};

  static StorageHelper? _instance;

  StorageHelper._internal() {
    _instance = this;
  }

  factory StorageHelper() => _instance ?? StorageHelper._internal();

  get localStorageMap => _localStorageMap;

  // refreshFileState is used to synchonize the local cache with
  // files as they currently exist on Firebase Storage.
  //
  // within the screen files, it is typically run before updateLocalStorageMap
  Future<void> refreshFileState() async {
    await _verifyRootExists();

    final remoteStorage = await _mapRemoteStorage();
    final localStorage = await _mapLocalStorage();

    for (final entry in remoteStorage.entries) {
      if (localStorage.containsKey(entry.key)) {
        for (final file in entry.value) {
          try {
            final localFile = localStorage[entry.key]!.firstWhere((element) => 
              element.path.split('/').last == file.name);

            final localLastModified = await localFile.lastModified();
            final remoteTimeCreated = await file.getMetadata().then((value) => value.timeCreated);

            // check if remote file has been updated; if so, delete (outdated)
            // local file and download new remote file
            if (localLastModified.compareTo(remoteTimeCreated!).isNegative) {
              await localFile.delete();
              await _downloadFile(file.fullPath);
            }

            // remove target local file from local storage map
            localStorage[entry.key]!.remove(localFile);
          } on StateError {
            await _downloadFile(file.fullPath);
          }
        }
      } else {
        for (final file in entry.value) {
          await _downloadFile(file.fullPath);
        }
      }
    }

    // delete directories that don't exist in Firebase
    final appDocDir = await getApplicationDocumentsDirectory();
    for (final directory in localStorage.keys) {
      if (!remoteStorage.keys.contains(directory)) {
        try {
          await Directory('${appDocDir.path}/$_rootDir/$directory').delete(recursive: true);
        } on FileSystemException {
          continue;
        }
      }
    }

    // delete files that don't have corresponding remote file
    for (final fileList in localStorage.values) {
      for (final file in fileList) {
        try {
          await file.delete();
        } on FileSystemException {
          continue;
        }
      }
    }
  }

  // updateLocalStorageMap populates _localStorageMap with StoredItem
  // objects which point to files in the cache.
  Future<void> updateLocalStorageMap() async {
    await _verifyRootExists();
    
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    _localStorageMap = {};

    await for (final directory in Directory('${appDocDir.path}/$_rootDir').list()) {
      directory as Directory;

      _localStorageMap[directory.path] = [];

      await for (final file in directory.list()) {
        final fileName = file.path.split('/').last;

        if (fileName != '.keep') {
          final parentDirectory = file.parent.toString().split('/').last.replaceAll('\'', '');

          _localStorageMap[directory.path]!.add(StoredItem(
              name: fileName.split('.').first,
              localFile: file as File,
              remoteReference: _storageInstance
                  .ref('$_rootDir/$parentDirectory/$fileName')));
        }
      }
    }

    // sort keys
    final sortedKeys = _localStorageMap.keys.toList(growable: false)
      ..sort((k1, k2) => k1.compareTo(k2));
    _localStorageMap = {for (final k in sortedKeys) k: _localStorageMap[k]!};

    // sort lists
    for (final list in _localStorageMap.values) {
      list.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  Future<void> uploadFile(File file, String remotePath) async {
    try {
      await _storageInstance.ref(remotePath).putFile(file);
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<void> createDirectory(String text) async {
    await _storageInstance.ref('$_rootDir/$text/.keep').putString('');
  }

  Future<void> deleteDirectory(String directory) async {
    final files = await _storageInstance.ref('$_rootDir/$directory').listAll();

    for (Reference file in files.items) {
      await file.delete();
    }
  }

  Future<void> deleteFile(StoredItem file) async {
    await file.remoteReference.delete();
  }

  Future<void> _verifyRootExists() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final rootProtocolDir = Directory('${appDocDir.path}/$_rootDir');

    if (!await rootProtocolDir.exists()) {
      rootProtocolDir.create();
    }
  }

  Future<Map<String, List<File>>> _mapLocalStorage() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final localMap = <String, List<File>>{};

    await for (final directory in Directory('${appDocDir.path}/$_rootDir').list()) {
      directory as Directory;
      final directoryName = directory.path.split('/').last;

      localMap[directoryName] = [];

      await for (final file in directory.list()) {
        localMap[directoryName]!.add(file as File);
      }
    }

    return localMap;
  }

  Future<Map<String, List<Reference>>> _mapRemoteStorage() async {
    final remoteMap = <String, List<Reference>>{};
    final remoteParentDirectories = await _storageInstance.ref('$_rootDir/').listAll();

    for (final parentDirectory in remoteParentDirectories.prefixes) {
      final directoryListing = await _storageInstance.ref(parentDirectory.fullPath).listAll();

      remoteMap[parentDirectory.name] = [];

      for (final file in directoryListing.items) {
        remoteMap[parentDirectory.name]!.add(file);
      }
    }

    return remoteMap;
  }

  Future<void> _downloadFile(String path) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File downloadToFile = File('${appDocDir.path}/$path');

    if (!await downloadToFile.parent.exists()) {
      await downloadToFile.parent.create();
    }

    try {
      await _storageInstance.ref(path).writeToFile(downloadToFile);
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }
}
