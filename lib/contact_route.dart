import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'styles.dart';

class ContactRoute extends StatelessWidget {

  const ContactRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacts',
          style: Styles.navBarTitle,
        )
      ),
      body: SfPdfViewer.asset('assets/RFR Phone List.pdf')
    );
  }
}