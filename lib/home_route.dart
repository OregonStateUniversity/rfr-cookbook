import 'dart:io';

import 'package:flutter/material.dart';
import 'models/pdf.dart';
import 'pdf_list.dart';
import 'storage_helper.dart';
import 'styles.dart';

class HomeRoute extends StatelessWidget {
  final StorageHelper _storageHelper = StorageHelper();

  HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _storageHelper.initialize(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData) {
          return ProtocolList(snapshot.data as Map<String, List<File>>);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}

class ProtocolList extends StatelessWidget {
  final Map<String, List<File>> protocols;

  const ProtocolList(
    this.protocols,
    {Key? key}
  ) : super(key: key);

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('theCookbook', style: Styles.navBarTitle),
        backgroundColor: Styles.navBarColor,
      ),
      body: ListView.builder(
        itemCount: protocols.length,
        itemBuilder: _listViewItemBuilder,
      )
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final targetDirectory = protocols.keys.toList()[index];
    final directoryName = targetDirectory.split('/').last;
    final fileList = protocols[targetDirectory];
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
          fileList.map((e) => Pdf(title: e.path.split('/').last.split('.').first, file: e)).toList(),
          sectionTitle
        )
      )
    );
  }

}