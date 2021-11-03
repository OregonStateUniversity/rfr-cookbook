import 'dart:io';
import 'package:flutter/material.dart';
import 'protocol_list.dart';
import 'storage_helper.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
      future: StorageHelper().initialize(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData) {
          return ProtocolList(snapshot.data as Map<String, List<File>>);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
      )
    );
  }
}
