import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'models/pdf.dart';
import 'styles.dart';

class PdfDetail extends StatelessWidget {
  final Pdf _pdf;

  const PdfDetail(this._pdf, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pdf.title, style: Styles.navBarTitle),
        backgroundColor: Styles.navBarColor,
      ),
      body: SfPdfViewer.asset(_pdf.path),
    );
  }
}