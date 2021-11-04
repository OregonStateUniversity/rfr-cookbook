import 'package:flutter/material.dart';
import 'package:rfr_cookbook/styles.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel', style: Styles.navBarTitle),
        backgroundColor: Styles.navBarColor,
      ),
      body: const Text('Admin Panel'),
    );
  }
  
}