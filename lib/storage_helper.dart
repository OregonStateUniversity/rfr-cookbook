import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rfr_cookbook/models/stored_item.dart';

class StorageHelper {
  static final FirebaseStorage _storageInstance = FirebaseStorage.instance;

  Future<Map<String, List<StoredItem>>> storageMap() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    Map<String, List<StoredItem>> storageMap = {};

    await for (final directory in Directory('${appDocDir.path}/protocols').list()) {
      directory as Directory;

      storageMap[directory.path] = [];

      await for (final file in directory.list()) {
        final fileName = file.path.split('/').last;
        
        if (fileName != '.keep') {
          final parentDirectory = file.parent.toString().split('/').last.replaceAll('\'', '');
          final metadata = await _storageInstance.ref('protocols/$parentDirectory/$fileName').getMetadata();
          
          storageMap[directory.path]!.add(
            StoredItem(
              name: fileName.split('.').first,
              uploadedAt: metadata.timeCreated!,
              localFile: file as File,
              remoteReference: _storageInstance
                .ref('protocols/$parentDirectory/$fileName')
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

  Future<void> uploadFileWithMetadata(File file, String remotePath) async {
    SettableMetadata metadata = SettableMetadata(
        customMetadata: <String, String>{'md5Hash': await _generateMd5(file)});

    try {
      _storageInstance.ref(remotePath).putFile(file, metadata);
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  void createDirectory(String text) {
    _storageInstance.ref('protocols/$text/.keep').putString('');
  }

  Future<void> deleteDirectory(String directory) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final files = await _storageInstance.ref('protocols/$directory').listAll();

    for (Reference file in files.items) {
      file.delete();
    }

    Directory('${appDocDir.path}/protocols/$directory').delete(recursive: true);
  }

  void deleteFile(StoredItem file) {
    file.localFile.delete();
    file.remoteReference.delete();
  }

  Future<void> deleteLocalRootDirectory() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory(appDocDir.path + '/protocols').delete(recursive: true);
  }

  Future<void> _verifyRootExists() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final rootProtocolDir = Directory(appDocDir.path + '/protocols');
    
    if (!await rootProtocolDir.exists()) {
      rootProtocolDir.create();
    }
  }

  Future<void> updateFileState() async {
    await _verifyRootExists();

    final remoteParentDirectories = 
      await _storageInstance.ref('protocols/').listAll();

    for (Reference parentDirectory in remoteParentDirectories.prefixes) {
      final ListResult directoryListing = 
        await _storageInstance.ref(parentDirectory.fullPath).listAll();

      for (Reference file in directoryListing.items) {
        if (!await _md5Match(file)) {
          _downloadFile(file.fullPath);
        }
      }
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

  Future<bool> _md5Match(Reference file) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File localFile = File('${appDocDir.path}/${file.fullPath}');
    final FullMetadata metadata = await file.getMetadata();

    if (await localFile.exists()) {
      return await _generateMd5(localFile) == metadata.customMetadata!['md5Hash'];
    }

    return false;
  }

  Future<String> _generateMd5(File file) async {
    final fileStream = file.openRead();
    return (await md5.bind(fileStream).first).toString();
  }
}
