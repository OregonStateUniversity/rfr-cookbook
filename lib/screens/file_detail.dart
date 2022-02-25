import 'package:flutter/material.dart';
import 'package:rfr_cookbook/models/stored_item.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:rfr_cookbook/config/styles.dart';
import 'package:rfr_cookbook/search.dart';
import 'package:rfr_cookbook/storage_helper.dart';

class FileDetail extends StatefulWidget {
  final StoredItem _file;
  const FileDetail(this._file, {Key? key}) : super(key: key);

  @override
  _FileDetailState createState() => _FileDetailState();
}

class _FileDetailState extends State<FileDetail> {
  //final StoredItem _file;

  //const FileDetail(this._file, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._file.name, style: Styles.navBarTitle),
        backgroundColor: Styles.themeColor,
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
        ],
      ),
      body: SfPdfViewer.file(widget._file.localFile),
    );
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
