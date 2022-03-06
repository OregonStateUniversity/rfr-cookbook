import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rfr_cookbook/models/stored_item.dart';
import 'package:rfr_cookbook/search.dart';
import 'package:rfr_cookbook/storage_helper.dart';
import 'package:rfr_cookbook/config/styles.dart';
import 'package:rfr_cookbook/widgets/app_bar.dart';
import 'admin_panel.dart';
import 'file_list.dart';
import 'login_form.dart';
import 'package:wiredash/wiredash.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _storageHelper = StorageHelper();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
            title: 'theCookbook',
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _navigationToAdminPanel(context),
            ),
            actions: [
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    showSearch(
                        context: context,
                        delegate: SearchBar(
                            allSearchResults: _searchList(context),
                            searchSuggestions: _searchList(context),
                            storedItemList: _storedItemList(context)));
                  }),
              IconButton(
                  onPressed: () => _loadFiles(),
                  icon: const Icon(Icons.refresh)),
            ]),
        body: ListView.builder(
          itemCount: _storageHelper.localStorageMap.length,
          itemBuilder: _listViewItemBuilder,
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Wiredash.of(context)!.show(),
            label: const Text('Feedback'),
            icon: const Icon(Icons.comment_outlined),
            backgroundColor: Styles.themeColor));
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final targetDirectory = _storageHelper.localStorageMap.keys.toList()[index];
    final directoryName = targetDirectory.split('/').last;
    final fileList = _storageHelper.localStorageMap[targetDirectory];
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

  Future<void> _initialize() async {
    await _storageHelper.updateLocalStorageMap();

    if (_storageHelper.localStorageMap.isEmpty) {
      _loadFiles();
    } else {
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _loadFiles() async {
    EasyLoading.show(status: 'Updating files...');
    await _storageHelper.refreshFileState();
    await _storageHelper.updateLocalStorageMap();
    await EasyLoading.dismiss();

    if (mounted) {
      setState(() {});
    }
  }

  List<String> _searchList(BuildContext context) {
    List<String> list =
        _storedItemList(context)!.map((file) => file.name).toList();
    return list;
  }

  List<StoredItem>? _storedItemList(BuildContext context) {
    final dirCount = _storageHelper.localStorageMap.keys.length;
    List<StoredItem> pdfList = [];
    for (int i = 0; i < dirCount; i++) {
      pdfList += _storageHelper.localStorageMap.values.toList()[i];
    }
    return pdfList;
  }
}
