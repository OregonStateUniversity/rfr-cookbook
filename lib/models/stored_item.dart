import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StoredItem {
  final String fileName;
  final File localFile;
  final Reference remoteReference;

  StoredItem({
    required this.fileName,
    required this.localFile,
    required this.remoteReference
  });
}