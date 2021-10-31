import 'package:firebase_storage/firebase_storage.dart';

class StorageHelper {
  final FirebaseStorage _storageInstance = FirebaseStorage.instance;

  Future<ListResult> get protocolList async {
    return await _storageInstance.ref('protocols/').listAll();
  }
}