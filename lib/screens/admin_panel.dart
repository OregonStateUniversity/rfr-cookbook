import 'package:firebase_auth/firebase_auth.dart';
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
        actions: [
          _renderPopupMenuButton(context),
        ],
      ),
      body: const Text('Admin Panel'),
    );
  }

  PopupMenuButton _renderPopupMenuButton(BuildContext context) {
    return PopupMenuButton(
      onSelected: (item) => _selectedItem(context, item as int),
      itemBuilder: (context) =>
      [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: const [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 7),
              Text('Logout')
            ],
          )
        )
      ]
    );
  }

  void _selectedItem(BuildContext context, int item) {
    switch (item) {
      case 0: // logout
        FirebaseAuth.instance.signOut();
        Navigator.of(context).pop();
        break;
    }
  }
  
}