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
        appBar: appBar(title: _sectionTitle, actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                showSearch(
                    context: context,
                    delegate: SearchBar(
                        allSearchResults: _searchList(),
                        searchSuggestions: _searchList(),
                        storedItemList: _storedItemList()));
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => FileDetail(file)));
  }

  List<String> _searchList() {
    return _storedItemList().map((file) => file.name).toList();
  }

  List<StoredItem> _storedItemList() {
    final StorageHelper _storageHelper = StorageHelper();
    return [
      for (final sublist in _storageHelper.localStorageMap.values) ...sublist
    ];
  }
}
