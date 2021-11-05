import 'package:flutter/material.dart';
import 'screens/protocol_list.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'The Cookbook',
      home: HomeScreen(),
    );
  } 
}