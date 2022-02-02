import 'package:flutter/material.dart';
import 'package:rfr_cookbook/styles.dart';
//import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
//import 'storage_helper.dart';
//import 'package:rfr_cookbook/screens/file_list.dart';
import 'package:rfr_cookbook/models/stored_item.dart';
//import 'package:rfr_cookbook/screens/home_screen.dart';
//import 'package:rfr_cookbook/models/stored_item.dart';
import 'package:rfr_cookbook/screens/file_detail.dart';
//import 'package:collection/src/iterable_extensions.dart';

//-import storage helper
//-use storage map function
//-get function to return list of string that contains
// all pdfs without folders
class SearchBar extends SearchDelegate<String> {
  final List<String> allSearchResults;
  final List<String> searchSuggestions;
  final List<StoredItem>? storedItemList;

  //const SearchBar({Key? key}) : super(key: key);
  SearchBar(
      {required this.allSearchResults,
      required this.searchSuggestions,
      required this.storedItemList});

  //final StorageHelper _storageHelper = StorageHelper();
  //Map<String, List<StoredItem>> _storageMap = {};

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
      ),
      textTheme: Theme.of(context).textTheme.copyWith(
            headline6: TextStyle(color: Colors.white, fontSize: 25.0),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: Styles.themeColor,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, "");
        });
  }

  //
  @override
  Widget buildResults(BuildContext context) {
    final List<String> allSearch = allSearchResults
        .where(
          (searchFor) => searchFor.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();

    StoredItem findPDF(String name) =>
        storedItemList!.firstWhere((pdf) => pdf.name == name,
            orElse: () => storedItemList![0]);

    return ListView.builder(
        itemCount: allSearch.length,
        itemBuilder: (context, index) => ListTile(
              title: Text(allSearch[index]),
              onTap: () {
                query = allSearch[index];
                close(context, query);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FileDetail(findPDF(allSearch[index]))));
              },
            ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> allSuggestions = searchSuggestions
        .where(
          (suggestion) => suggestion.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();

    return ListView.builder(
        itemCount: allSuggestions.length,
        itemBuilder: (context, index) => ListTile(
              title: Text(allSuggestions[index]),
              onTap: () {
                query = allSuggestions[index];
                close(context, query);
              },
            ));
  }
/*
  void findPDF(BuildContext context, String sectionTitle, int index) {
    final targetDirectory = _storageMap.keys.toList()[index];
    final directoryName = targetDirectory.split('/').last;
    final fileList = _storageMap[targetDirectory];
    FileList(fileList!, sectionTitle);
  }*/
}
