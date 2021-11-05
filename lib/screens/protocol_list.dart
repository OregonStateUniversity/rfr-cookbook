import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rfr_cookbook/models/pdf.dart';
import 'package:rfr_cookbook/storage_helper.dart';
import 'package:rfr_cookbook/styles.dart';
import 'admin_panel.dart';
import 'pdf_list.dart';
import 'login_form.dart';

class ProtocolList extends StatefulWidget {
  const ProtocolList({Key? key}) : super(key: key);

  @override
  _ProtocolListState createState() => _ProtocolListState();
}


class _ProtocolListState extends State<ProtocolList> {
  Map<String, List<File>> _protocolDirectories = {};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: StorageHelper().updateFileState(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData) {
          _protocolDirectories = snapshot.data as Map<String, List<File>>;
          return _renderMaterialApp(context);
        } else {
          return const Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
              height: 50.0,
              width: 50.0,
            )
          );
        }
      }
    );
  }

  Widget _renderMaterialApp(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('theCookbook', style: Styles.navBarTitle),
        backgroundColor: Styles.navBarColor,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _navigationToLoginForm(context),
        ),
        actions: [
          _renderIconButton(context),
        ],
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
        onTap: () => _navigationToPdfList(context, directoryName, fileList!)
      ),
    );
  }

  void _navigationToPdfList(BuildContext context, String sectionTitle, List<File> fileList) {
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

  void _navigationToLoginForm(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => user == null ? const LoginForm() : const AdminPanel()
      )
    );
  }

  Widget _renderIconButton(BuildContext context) {
    return IconButton(
      onPressed: () => _updateFileState(context),
      icon: const Icon(Icons.refresh)
    );
  }

  Future<void> _updateFileState(BuildContext context) async {
    final newFileState = await StorageHelper().updateFileState() as Map<String, List<File>>;
    
    setState(() {
      _protocolDirectories = newFileState;
    });

    ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(
        content: Text('File state updated.', textAlign: TextAlign.center,)
        )
      );
  }

  String _parseFileName(File file) {
    return file.path.split('/').last.split('.').first;
  }
}