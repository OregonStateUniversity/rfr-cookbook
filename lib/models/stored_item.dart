import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StoredItem {
  final String name;
  final DateTime uploadedAt;
  final File localFile;
  final Reference remoteReference;

  StoredItem({
    required this.name,
    required this.uploadedAt,
    required this.localFile,
    required this.remoteReference
  });
}