import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class StorageHelper {
  static final FirebaseStorage _storageInstance = FirebaseStorage.instance;

  Future<void> initializeStorage() async {
    final ListResult remoteParentDirectories = await _remoteDirectoryList;

    for (Reference parentDirectory in remoteParentDirectories.prefixes) {
      final ListResult directoryList = await _storageInstance.ref(parentDirectory.fullPath).listAll();

      for (Reference file in directoryList.items) {
        _downloadFile(file);
      }
    }
  }

  Future<void> _uploadFileWithMetadata(String localPath, String remotePath) async {
    File file = File(localPath);

    SettableMetadata metadata = SettableMetadata(
      customMetadata: <String, String>{'md5Hash': await _generateMd5(localPath)}
    );

    try {
      await _storageInstance.ref(remotePath).putFile(file, metadata);
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<String> _generateMd5(String pathToFile) async {
    final fileStream = File(pathToFile).openRead();
    return (await md5.bind(fileStream).first).toString();
  }

  Future<void> _downloadFile(Reference ref) async {
    final String appDocDir = await _localRootPath;
    final File downloadToFile = File('$appDocDir/${ref.fullPath}');

    try {
      await _storageInstance
        .ref(ref.fullPath)
        .writeToFile(downloadToFile);
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<String> get _localRootPath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<ListResult> get _remoteDirectoryList async {
    return await _storageInstance.ref('protocols/').listAll();
  }
}