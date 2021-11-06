import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rfr_cookbook/storage_helper.dart';
import 'package:rfr_cookbook/styles.dart';

const FooterHeight = 100.0;

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final StorageHelper _storageHelper = StorageHelper();
  Map<String, List<File>> _protocolDirectories = {};

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel', style: Styles.navBarTitle),
        backgroundColor: Styles.navBarColor,
        actions: [
          _renderPopupMenu(context)
        ],
      ),
      body: _renderBody(context)
    );
  }

  Future<void> _loadFiles() async {
    final files = await _storageHelper.directoryMap();

    if (mounted) {
      setState(() {
        _protocolDirectories = files as Map<String, List<File>>;
      });
    }
  }

  Widget _renderPopupMenu(BuildContext context) {
    return PopupMenuButton(
      onSelected: (item) => _selectedItem(context, item as int),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: const [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 7),
              Text('Logout')
            ])
        )
      ]
    );
  }

  Widget _renderBody(BuildContext context) {
    return const Text('Admin Panel Body');
  }

  void _selectedItem(BuildContext context, int item) {
    switch (item) {
      case 0: // logout
        _handleLogout(context);
        break;
      default:
    }
  }

  void _handleLogout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          backgroundColor: Colors.black.withOpacity(0.5),
          content: const Text('You have been logged out.', textAlign: TextAlign.center)
        )
      );
  }
}