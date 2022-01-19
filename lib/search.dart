import 'package:flutter/material.dart';
import 'package:rfr_cookbook/styles.dart';

class SearchBar extends SearchDelegate<String> {
  //change this to use firebase
  final searchFor = [
    //0-Preface
    "00-010 Scope of Practice",
    "00-020 Advance Directives",
    "00-030 Death in the Field",
    "00-040 Glasgow Coma Scale",
    "00-050 Medical Control for Drugs & Procedures",
    "00-060 Universal Patient Care",
    "00-070 BLS Guidelines for single role EMT's",
    //1-Treatment
    "10-010 Abdominal Pain",
    "10-020 Altered Mental Status",
    "10-030 Anaphylaxis",
    "10-040 Burns",
    "10-050 Cardiac Arrest - AED-CPR-HP CPR",
    "10-051 Cardiac Arrest - Asystole"
    //2-Medications
    //3-Procedures
    //4-Operations
    //5-Trauma
    //6-Hazmat
    //7-Misc
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
