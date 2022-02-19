import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
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
  final StorageHelper _storageHelper = StorageHelper();
  String selectedResult = "";

  @override
  void initState() {
    super.initState();
    _loadFiles();
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
              IconButton(
                  onPressed: () => _handleLocalFileDeletion(context),
                  icon: const Icon(Icons.delete))
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

  Future<void> _loadFiles() async {
    EasyLoading.show(status: 'Refreshing files...');
    await _storageHelper.refreshFileState();
    await _storageHelper.updateLocalStorageMap();
    await EasyLoading.dismiss();

    if (mounted) {
      setState(() {});
    }
  }

  _handleLocalFileDeletion(BuildContext context) {
    showPlatformDialog(
        context: context,
        builder: (context) => BasicDialogAlert(
              title: const Text('Delete local files?'),
              actions: [
                BasicDialogAction(
                  title: Text('Yes', style: Styles.textDefault),
                  onPressed: () async {
                    await _storageHelper.deleteLocalFiles();
                    await _storageHelper.updateLocalStorageMap();
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
                BasicDialogAction(
                  title: Text('No', style: Styles.textDefault),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }

  List<String> _searchList(BuildContext context) {
    List<String> list =
        _storedItemList(context)!.map((file) => file.name).toList();
    return list;
  }

  List<StoredItem>? _storedItemList(BuildContext context) {
    List<StoredItem> pdfList = [];
    for (int i = 0; i <= 7; i++) {
      pdfList += _storageHelper.localStorageMap.values.toList()[i];
    }
    return pdfList;
  }
}
