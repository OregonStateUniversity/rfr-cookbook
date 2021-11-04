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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: ElevatedButton(
              style: Styles.buttonStyle,
              child: Text('Logout', style: Styles.buttonText),
              onPressed: () {
                _logout(context);
              },
            ),
          )
        ]
      )
    );
  }

  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      .showSnackBar(
        const SnackBar(
          content: Text('You have been logged out.', textAlign: TextAlign.center)
        )
      );
  }
}