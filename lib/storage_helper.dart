import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class StorageHelper {
  static final FirebaseStorage _storageInstance = FirebaseStorage.instance;

  Future<Map> updateFileState() async {
    _verifyRootExists();
    _updateFiles();
    return directoryMap();
  }

  Future<Map> directoryMap() async {
    Map<String, List<File>> protocols = {};
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    await for (final directory in Directory('${appDocDir.path}/protocols').list()) {
      directory as Directory;

      protocols[directory.path] = [];

      await for (final file in directory.list()) {
        protocols[directory.path]!.add(file as File);
      }
    }

    // sort keys
    final sortedKeys = protocols.keys.toList(growable: false)..sort((k1, k2) => k1.compareTo(k2));
    protocols = { for (final k in sortedKeys) k : protocols[k]! };
    
    // sort lists
    for (final list in protocols.values) {
      list.sort((a, b) => a.path.compareTo(b.path));
    }

    return protocols;
  }

  Future<void> _verifyRootExists() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final rootProtocolDir = Directory(appDocDir.path + '/protocols');
    
    if (!await rootProtocolDir.exists()) {
      rootProtocolDir.create();
    }
  }

  Future<void> _updateFiles() async {
    final ListResult remoteParentDirectories = 
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

  Future<void> _deleteLocalRootDirectory() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory(appDocDir.path + '/protocols').delete(recursive: true);
  }

  Future<void> _uploadFileWithMetadata(String localPath, String remotePath) async {
    File file = File(localPath);

    SettableMetadata metadata = SettableMetadata(
      customMetadata: <String, String>{'md5Hash': await _generateMd5(file)}
    );

    try {
      await _storageInstance.ref(remotePath).putFile(file, metadata);
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<void> _downloadFile(String path) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File downloadToFile = File('${appDocDir.path}/$path');

    if (!await downloadToFile.parent.exists()) {
      downloadToFile.parent.create();
    }

    try {
      await _storageInstance
        .ref(path)
        .writeToFile(downloadToFile);
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