import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rfr_cookbook/models/stored_item.dart';
import 'package:rfr_cookbook/storage_helper.dart';
import 'package:rfr_cookbook/styles.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final StorageHelper _storageHelper = StorageHelper();
  Map<String, List<StoredItem>> _storageMap = {};

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
      body: ListView.builder(
        itemCount: _storageMap.length,
        itemBuilder: _listViewItemBuilder
      )
    );
  }

  Future<void> _loadFiles() async {
    final storageMap = await _storageHelper.localStorageMap();

    if (mounted) {
      setState(() {
        _storageMap = storageMap;
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

  void _selectedItem(BuildContext context, int item) {
    switch (item) {
      case 0: // logout
        _handleLogout(context);
        break;
      default:
    }
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final targetDirectory = _storageMap.keys.toList()[index];
    final directoryName = targetDirectory.split('/').last;
    final fileList = _storageMap[targetDirectory];
    return Card(
      child: ExpansionTile(
        title: Text(directoryName, style: Styles.textDefault),
        children: _buildExpandableContent(context, fileList!),
      )
    );
  }

  List<Widget> _buildExpandableContent(BuildContext context, List<StoredItem> list) {
    return list.map((file) => 
      Card(
        child: ListTile(
          title: Text(file.name, style: Styles.textDefault),
          onTap: () => _renderActionSnackbar(context, file),
        )
      )
    ).toList();
  }

  void _renderActionSnackbar(BuildContext context, StoredItem file) {
    ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          content: Text('Delete "${file.name}"?'),
          action: SnackBarAction(
            label: 'Delete',
            onPressed: () => _storageHelper.deleteFile(file),
          ),
        )
      );
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