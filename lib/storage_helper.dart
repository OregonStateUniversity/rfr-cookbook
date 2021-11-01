import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class StorageHelper {
  static final FirebaseStorage _storageInstance = FirebaseStorage.instance;

  Future<void> initializeLocalStorage() async {
    ListResult remoteParentDirectories = await _remoteDirectoryList;

    for (Reference parentDirectory in remoteParentDirectories.prefixes) {
      ListResult listResult = await _storageInstance.ref(parentDirectory.fullPath).listAll();
      for (Reference file in listResult.items) {
        _downloadFile(file);
      }
    }
  }

  Future<void> _downloadFile(Reference ref) async {
    String appDocDir = await _localRootPath;
    File downloadToFile = File('$appDocDir/${ref.fullPath}');
    
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