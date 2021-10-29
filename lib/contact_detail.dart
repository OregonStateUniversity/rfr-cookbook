import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'styles.dart';

class ContactDetail extends StatelessWidget {
  final String _phoneListPath = 'lib/assets/RFR Phone List.pdf';

  const ContactDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts', style: Styles.navBarTitle),
        backgroundColor: Styles.navBarColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu),
            iconSize: 42,
            onPressed: () => {},
          )
        ],
      ),
      body: SfPdfViewer.asset(_phoneListPath),
    );
  }
}