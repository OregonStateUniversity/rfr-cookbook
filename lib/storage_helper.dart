import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rfr_cookbook/models/stored_item.dart';

class StorageHelper {
  static final FirebaseStorage _storageInstance = FirebaseStorage.instance;
  static const _rootDir = 'protocols';

  Future<void> updateFiles() async {
    await _verifyRootExists();

    final remoteStorage = await _mapRemoteStorage();
    final localStorage = await _mapLocalStorage();

    for (final entry in remoteStorage.entries) {
      if (localStorage.containsKey(entry.key)) {
        
        for (final file in entry.value) {
          try {
            final localFile = localStorage[entry.key]!
              .where((element) => element.path.split('/').last == file.name).first;
            final localLastModified = await localFile.lastModified();
            final remoteTimeCreated = await file.getMetadata()
              .then((value) => value.timeCreated);

            if (localLastModified.compareTo(remoteTimeCreated!).isNegative) {
              localFile.delete();
              _downloadFile(file.fullPath);
            }

            localStorage[entry.key]!.remove(localFile);
          } on StateError {
            _downloadFile(file.fullPath);
          }
        }
      } else {
        for (final file in entry.value) {
          _downloadFile(file.fullPath);
        }
      }
    }

    for (final fileList in localStorage.values) {
      for (final file in fileList) {
        file.delete();
      }
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
      final ListResult directoryListing = await _storageInstance.ref(parentDirectory.fullPath).listAll();

      remoteMap[parentDirectory.name] = [];

      for (final file in directoryListing.items) {
        remoteMap[parentDirectory.name]!.add(file);
      }
    }

    return remoteMap;
  }

  Future<Map<String, List<StoredItem>>> localStorageMap() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    Map<String, List<StoredItem>> storageMap = {};

    await for (final directory in Directory('${appDocDir.path}/$_rootDir').list()) {
      directory as Directory;

      storageMap[directory.path] = [];

      await for (final file in directory.list()) {
        final fileName = file.path.split('/').last;
        
        if (fileName != '.keep') {
          final parentDirectory = file.parent.toString().split('/').last.replaceAll('\'', '');
          
          storageMap[directory.path]!.add(
            StoredItem(
              name: fileName.split('.').first,
              localFile: file as File,
              remoteReference: _storageInstance
                .ref('$_rootDir/$parentDirectory/$fileName')
            )
          );
        }
      }
    }

    // sort keys
    final sortedKeys = storageMap.keys.toList(growable: false)..sort((k1, k2) => k1.compareTo(k2));
    storageMap = { for (final k in sortedKeys) k : storageMap[k]! };
    
    // sort lists
    for (final list in storageMap.values) {
      list.sort((a, b) => a.name.compareTo(b.name));
    }

    return storageMap;
  }

  Future<void> uploadFile(File file, String remotePath) async {
    try {
      _storageInstance.ref(remotePath).putFile(file);
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  void createDirectory(String text) {
    _storageInstance.ref('$_rootDir/$text/.keep').putString('');
  }

  Future<void> deleteDirectory(String directory) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final files = await _storageInstance.ref('$_rootDir/$directory').listAll();

    for (Reference file in files.items) {
      file.delete();
    }

    Directory('${appDocDir.path}/$_rootDir/$directory').delete(recursive: true);
  }

  void deleteFile(StoredItem file) {
    file.localFile.delete();
    file.remoteReference.delete();
  }

  Future<void> deleteLocalRootDirectory() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory('${appDocDir.path}/$_rootDir').delete(recursive: true);
  }

  Future<void> _verifyRootExists() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final rootProtocolDir = Directory('${appDocDir.path}/$_rootDir');
    
    if (!await rootProtocolDir.exists()) {
      rootProtocolDir.create();
    }
  }

  Future<void> _downloadFile(String path) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File downloadToFile = File('${appDocDir.path}/$path');

    if (!await downloadToFile.parent.exists()) {
      downloadToFile.parent.create();
    }

    try {
      await _storageInstance.ref(path).writeToFile(downloadToFile);
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }
}
