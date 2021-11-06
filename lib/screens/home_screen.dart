import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rfr_cookbook/models/pdf.dart';
import 'package:rfr_cookbook/models/stored_item.dart';
import 'package:rfr_cookbook/search.dart';
import 'package:rfr_cookbook/storage_helper.dart';
import 'package:rfr_cookbook/styles.dart';
import 'admin_panel.dart';
import 'pdf_list.dart';
import 'login_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageHelper _storageHelper = StorageHelper();
  Map<String, List<StoredItem>> _storageMap = {};

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('theCookbook', style: Styles.navBarTitle),
        backgroundColor: Styles.navBarColor,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _navigationToAdminPanel(context),
        ),
        actions: [
          IconButton(
              onPressed: () => _updateFiles(context),
              icon: const Icon(Icons.refresh)),
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: SearchBar());
              }),
        ],
      ),
      body: ListView.builder(
        itemCount: _storageMap.length,
        itemBuilder: _listViewItemBuilder,
      )
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final targetDirectory = _storageMap.keys.toList()[index];
    final directoryName = targetDirectory.split('/').last;
    final fileList = _storageMap[targetDirectory];
    return Card(
      child: ListTile(
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          title: Text(directoryName, style: Styles.textDefault),
          onTap: () => _navigationToPdfList(context, directoryName, fileList!)
      ),
    );
  }

  void _navigationToPdfList(BuildContext context, String sectionTitle, List<StoredItem> fileList) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PdfList(
        fileList.map((file) => Pdf(title: file.fileName, fileObject: file.localFile)).toList(),
        sectionTitle)
      )
    );
  }

  void _navigationToAdminPanel(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => user == null ? const LoginForm() : const AdminPanel()
        )
    );
  }

  Future<void> _loadFiles() async {
    _storageHelper.updateFileState();
    final storageMap = await _storageHelper.storageMap();

    if (mounted) {
      setState(() {
        _storageMap = storageMap;
      });
    }
  }

  Future<void> _updateFiles(BuildContext context) async {
    _loadFiles();

    ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          backgroundColor: Colors.black.withOpacity(0.5),
          content: const Text('Checking for new files...', textAlign: TextAlign.center)
        )
      );
  }
}
