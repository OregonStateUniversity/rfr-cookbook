import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  
  runApp(MaterialApp(
    home: FutureBuilder(
      future: _fbApp,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData) {
          return HomeRoute();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    )
  ));
}