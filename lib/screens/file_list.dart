import 'package:flutter/material.dart';
import 'package:rfr_cookbook/models/stored_item.dart';
import 'package:rfr_cookbook/screens/file_detail.dart';
import 'package:rfr_cookbook/config/styles.dart';
import 'package:rfr_cookbook/storage_helper.dart';
import 'package:rfr_cookbook/widgets/app_bar.dart';
import 'package:wiredash/wiredash.dart';
import 'package:rfr_cookbook/search.dart';

class FileList extends StatelessWidget {
  final List<StoredItem> _fileList;
  final String _sectionTitle;

  const FileList(this._fileList, this._sectionTitle, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
          title: _sectionTitle,
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
          ]),
        body: ListView.builder(
          itemCount: _fileList.length,
          itemBuilder: _listViewItemBuilder,
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Wiredash.of(context)!.show(),
            label: const Text('Feedback'),
            icon: const Icon(Icons.comment_outlined),
            backgroundColor: Styles.themeColor));
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final pdf = _fileList[index];
    return Card(
        child: ListTile(
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            title: Text(pdf.name, style: Styles.textDefault),
            onTap: () => _navigationToDetail(context, pdf)));
  }

  void _navigationToDetail(BuildContext context, StoredItem file) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FileDetail(file)));
  }

  List<String> _searchList(BuildContext context) {
    List<String> list =
        _storedItemList(context)!.map((file) => file.name).toList();
    return list;
  }

  List<StoredItem>? _storedItemList(BuildContext context) {
    final StorageHelper _storageHelper = StorageHelper();
    List<StoredItem> pdfList = [];
    for (int i = 0; i <= 7; i++) {
      pdfList += _storageHelper.localStorageMap.values.toList()[i];
    }
    return pdfList;
  }
}
