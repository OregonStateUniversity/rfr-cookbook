import 'package:flutter/material.dart';
import 'package:rfr_cookbook/config/styles.dart';
import 'package:rfr_cookbook/models/stored_item.dart';
import 'package:rfr_cookbook/screens/file_detail.dart';

class SearchBar extends SearchDelegate<String> {
  final List<String> allSearchResults;
  final List<String> searchSuggestions;
  final List<StoredItem>? storedItemList;

  SearchBar(
      {required this.allSearchResults,
      required this.searchSuggestions,
      required this.storedItemList});

  StoredItem findPDF(String name) => storedItemList!
      .firstWhere((pdf) => pdf.name == name, orElse: () => storedItemList![0]);

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

  @override
  Widget buildResults(BuildContext context) {
    final List<String> allSearch = allSearchResults
        .where(
          (searchFor) => searchFor.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FileDetail(findPDF(allSuggestions[index]))));
              },
            ));
  }
}
