import 'package:flutter/material.dart';
import 'package:rfr_cookbook/models/stored_item.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:rfr_cookbook/config/styles.dart';
import 'package:rfr_cookbook/search.dart';
import 'package:rfr_cookbook/storage_helper.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class FileDetail extends StatefulWidget {
  final StoredItem _file;
  const FileDetail(this._file, {Key? key}) : super(key: key);

  @override
  _FileDetailState createState() => _FileDetailState();
}

class _FileDetailState extends State<FileDetail> {
  late PdfViewerController _pdfViewerController;
  late PdfTextSearchResult _searchResult;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    _searchResult = PdfTextSearchResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._file.name, style: Styles.navBarTitle),
        backgroundColor: Styles.themeColor,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                print("we are getting here");
                _searchResult = await _pdfViewerController.searchText('pain',
                    searchOption: TextSearchOption.caseSensitive);
                if (_searchResult.totalInstanceCount == 0) {
                  print('No matches found.');
                }
                print(
                    'Total instance count: ${_searchResult.totalInstanceCount}');
                setState(() {});

                /*
                showSearch(
                    context: context,
                    delegate: SearchBar(
                        allSearchResults: _searchList(context),
                        searchSuggestions: _searchList(context),
                        storedItemList: _storedItemList(context)));
              */
              }),
        ],
      ),
      body: SfPdfViewer.file(widget._file.localFile,
          controller: _pdfViewerController),
    );
  }
/*
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
  }*/
}
