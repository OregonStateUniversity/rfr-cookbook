import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rfr_cookbook/models/stored_item.dart';
import 'package:rfr_cookbook/search.dart';
import 'package:rfr_cookbook/storage_helper.dart';
import 'package:rfr_cookbook/styles.dart';
import 'admin_panel.dart';
import 'file_list.dart';
import 'login_form.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageHelper _storageHelper = StorageHelper();
  Map<String, List<StoredItem>> _storageMap = {};
  String selectedResult = "";

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
          backgroundColor: Styles.themeColor,
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
                onPressed: () async {
                  showSearch(
                      context: context,
                      delegate: SearchBar(
                          allSearchResults: searchList(context),
                          searchSuggestions: searchList(context),
                          storedItemList: storedItemList(context)));
                }),
          ],
        ),
        body: ListView.builder(
          itemCount: _storageMap.length,
          itemBuilder: _listViewItemBuilder,
        ));
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final targetDirectory = _storageMap.keys.toList()[index];
    final directoryName = targetDirectory.split('/').last;
    final fileList = _storageMap[targetDirectory];
    return Card(
      child: ListTile(
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          title: Text(directoryName, style: Styles.textDefault),
          onTap: () => _navigationToPdfList(context, directoryName, fileList!)),
    );
  }

  void _navigationToPdfList(
      BuildContext context, String sectionTitle, List<StoredItem> fileList) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FileList(fileList, sectionTitle)));
  }

  void _navigationToAdminPanel(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                user == null ? const LoginForm() : const AdminPanel()));
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

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        content: const Text('Checking for new files...',
            textAlign: TextAlign.center)));
  }

  List<String> searchList(BuildContext context) {
    final targetDirectory = _storageMap.keys.toList()[0];
    final targetDirectory1 = _storageMap.keys.toList()[1];
    final targetDirectory2 = _storageMap.keys.toList()[2];
    final targetDirectory3 = _storageMap.keys.toList()[3];
    final targetDirectory4 = _storageMap.keys.toList()[4];
    final targetDirectory5 = _storageMap.keys.toList()[5];
    final targetDirectory6 = _storageMap.keys.toList()[6];
    final targetDirectory7 = _storageMap.keys.toList()[7];
    final fileList = _storageMap[targetDirectory];
    final fileList1 = _storageMap[targetDirectory1];
    final fileList2 = _storageMap[targetDirectory2];
    final fileList3 = _storageMap[targetDirectory3];
    final fileList4 = _storageMap[targetDirectory4];
    final fileList5 = _storageMap[targetDirectory5];
    final fileList6 = _storageMap[targetDirectory6];
    final fileList7 = _storageMap[targetDirectory7];
    List<StoredItem> finalList = fileList! +
        fileList1! +
        fileList2! +
        fileList3! +
        fileList4! +
        fileList5! +
        fileList6! +
        fileList7!;
    List<String> list = finalList.map((file) => file.name).toList();
    return list;
  }

  List<StoredItem>? storedItemList(BuildContext context) {
    final targetDirectory = _storageMap.keys.toList()[0];
    final targetDirectory1 = _storageMap.keys.toList()[1];
    final targetDirectory2 = _storageMap.keys.toList()[2];
    final targetDirectory3 = _storageMap.keys.toList()[3];
    final targetDirectory4 = _storageMap.keys.toList()[4];
    final targetDirectory5 = _storageMap.keys.toList()[5];
    final targetDirectory6 = _storageMap.keys.toList()[6];
    final targetDirectory7 = _storageMap.keys.toList()[7];
    final fileList = _storageMap[targetDirectory];
    final fileList1 = _storageMap[targetDirectory1];
    final fileList2 = _storageMap[targetDirectory2];
    final fileList3 = _storageMap[targetDirectory3];
    final fileList4 = _storageMap[targetDirectory4];
    final fileList5 = _storageMap[targetDirectory5];
    final fileList6 = _storageMap[targetDirectory6];
    final fileList7 = _storageMap[targetDirectory7];
    List<StoredItem> finalList = fileList! +
        fileList1! +
        fileList2! +
        fileList3! +
        fileList4! +
        fileList5! +
        fileList6! +
        fileList7!;
    return finalList;
  }
}
