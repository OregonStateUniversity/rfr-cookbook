import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(FutureBuilder(
    future: Firebase.initializeApp(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      } else if (snapshot.hasData) {
        return const App();
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  ));
}
