import 'dart:io';
import 'package:flutter/material.dart';
import 'models/pdf.dart';
import 'pdf_list.dart';
import 'styles.dart';

class ProtocolList extends StatelessWidget {
  final Map<String, List<File>> _protocolDirectories;

  const ProtocolList(this._protocolDirectories, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('theCookbook', style: Styles.navBarTitle),
        backgroundColor: Styles.navBarColor,
      ),
      body: ListView.builder(
        itemCount: _protocolDirectories.length,
        itemBuilder: _listViewItemBuilder,
      )
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final targetDirectory = _protocolDirectories.keys.toList()[index];
    final directoryName = targetDirectory.split('/').last;
    final fileList = _protocolDirectories[targetDirectory];
    return Card(
      child: ListTile(
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        title: Text(directoryName, style: Styles.textDefault),
        onTap: () => _navigationTo(context, directoryName, fileList!)
      ),
    );
  }

  void _navigationTo(BuildContext context, String sectionTitle, List<File> fileList) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfList(
          fileList.map((file) => Pdf(title: _parseFileName(file), fileObject: file)).toList(),
          sectionTitle
        )
      )
    );
  }

  String _parseFileName(File file) {
    return file.path.split('/').last.split('.').first;
  }
}