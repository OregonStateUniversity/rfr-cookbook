import 'package:flutter/material.dart';
import 'package:rfr_cookbook/models/stored_item.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:rfr_cookbook/styles.dart';

class FileDetail extends StatelessWidget {
  final StoredItem _file;

  const FileDetail(this._file, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_file.name, style: Styles.navBarTitle),
        backgroundColor: Styles.navBarColor,
      ),
      body: SfPdfViewer.file(_file.localFile),
    );
  }
}