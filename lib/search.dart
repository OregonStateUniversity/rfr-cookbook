import 'package:flutter/material.dart';
import 'package:rfr_cookbook/styles.dart';


class SearchBar extends SearchDelegate<String> {

  //change this to use firebase
  final searchFor = [
    "One thing",
    "Two thing",
    "Three thing",
    "Four thing",
    "Five thing",
    "Six thing",
    "Seven thing",
  ];

  final recentSearches = [
    "One thing",
    "Two thing",
    "Three thing",
    "Four thing",
  ];

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
      appBarTheme: AppBarTheme(
        backgroundColor: Styles.themeColor,
        foregroundColor: Colors.white,
        //to-do: change text to white
        //to-do: get rid of weird underline
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
    //I think this should return the pdf of the protocol....
    //This is just a placeholder to see if it does something
    return Container(
      height: 100,
      width: 100,
      child: Card(
        color: Colors.red,
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSearches
        : searchFor.where((typedWord) => typedWord.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                  text: suggestionList[index].substring(query.length),
                  style: const TextStyle(color: Colors.grey))
            ])),
      ),
      itemCount: suggestionList.length,
    );
  }
}
