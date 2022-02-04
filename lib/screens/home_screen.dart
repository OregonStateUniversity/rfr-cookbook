import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rfr_cookbook/models/stored_item.dart';
import 'package:rfr_cookbook/search.dart';
import 'package:rfr_cookbook/storage_helper.dart';
import 'package:rfr_cookbook/styles.dart';
import 'package:rfr_cookbook/utils/snackbar.dart';
import 'admin_panel.dart';
import 'file_list.dart';
import 'login_form.dart';

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
    displaySnackbar(context, 'Checking for new files...');
  }

  List<String> searchList(BuildContext context) {
    final pdfList = _storageMap.values.toList()[0];
    final pdfList1 = _storageMap.values.toList()[1];
    final pdfList2 = _storageMap.values.toList()[2];
    final pdfList3 = _storageMap.values.toList()[3];
    final pdfList4 = _storageMap.values.toList()[4];
    final pdfList5 = _storageMap.values.toList()[5];
    final pdfList6 = _storageMap.values.toList()[6];
    final pdfList7 = _storageMap.values.toList()[7];
    List<StoredItem> finalList = pdfList +
        pdfList1 +
        pdfList2 +
        pdfList3 +
        pdfList4 +
        pdfList5 +
        pdfList6 +
        pdfList7;

    List<String> list = finalList.map((file) => file.name).toList();
    return list;
  }

  List<StoredItem>? storedItemList(BuildContext context) {
    final pdfList = _storageMap.values.toList()[0];
    final pdfList1 = _storageMap.values.toList()[1];
    final pdfList2 = _storageMap.values.toList()[2];
    final pdfList3 = _storageMap.values.toList()[3];
    final pdfList4 = _storageMap.values.toList()[4];
    final pdfList5 = _storageMap.values.toList()[5];
    final pdfList6 = _storageMap.values.toList()[6];
    final pdfList7 = _storageMap.values.toList()[7];
    List<StoredItem> finalList = pdfList +
        pdfList1 +
        pdfList2 +
        pdfList3 +
        pdfList4 +
        pdfList5 +
        pdfList6 +
        pdfList7;
    return finalList;
  }
}
