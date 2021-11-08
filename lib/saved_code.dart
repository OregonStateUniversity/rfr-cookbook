Future<void> uploadFiles() async {
  final parentDir = Directory('/Users/myles/Documents/Projects/rfr_cookbook/protocols');

  await for (final directory in parentDir.list()) {
    directory as Directory;
    final directoryName = directory.path.split('/').last;

    await for (final file in directory.list()) {
      file as File;
      final fileName = file.path.split('/').last.split('.').first;

      SettableMetadata metadata = SettableMetadata(
        customMetadata: <String, String>{'md5Hash': await _generateMd5(file)}
      );

      try {
        await _storageInstance.ref('/protocols/$directoryName/$fileName').putFile(file, metadata);
      } on FirebaseException catch (e) {
        throw e.code;
      }
    }
  }
}