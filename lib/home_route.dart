import 'dart:io';

import 'package:flutter/material.dart';
import 'models/pdf.dart';
import 'pdf_list.dart';
import 'storage_helper.dart';
import 'styles.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  _HomeRouteState createState() => _HomeRouteState();
}


class _HomeRouteState extends State<HomeRoute> {
  final StorageHelper _storageHelper = StorageHelper();


  @override
  void initState() {
    super.initState();
    _storageHelper.initializeStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('theCookbook', style: Styles.navBarTitle),
        backgroundColor: Styles.navBarColor,
      ),
      body: ListView.builder(
        itemCount: _storageHelper.protocols.length,
        itemBuilder: _listViewItemBuilder,
      )
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final targetDirectory = _storageHelper.protocols.keys.toList()[index];
    final directoryName = targetDirectory.split('/').last;
    final fileList = _storageHelper.protocols[targetDirectory];
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
          fileList.map((e) => Pdf(title: e.path.split('/').last, path: e.path)).toList(),
          sectionTitle
        )
      )
    );
  }

}