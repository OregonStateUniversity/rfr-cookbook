import 'package:flutter/material.dart';
import 'package:rfr_cookbook/models/stored_item.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:rfr_cookbook/styles.dart';

class PdfDetail extends StatelessWidget {
  final StoredItem _pdf;

  const PdfDetail(this._pdf, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pdf.fileName, style: Styles.navBarTitle),
        backgroundColor: Styles.navBarColor,
      ),
      body: SfPdfViewer.file(_pdf.localFile),
    );
  }
}