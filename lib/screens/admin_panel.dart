import 'dart:io';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
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
        backgroundColor: Styles.themeColor,
        actions: [
          IconButton(
            onPressed: () => _updateFiles(context),
            icon: const Icon(Icons.refresh)
          ),
          _renderPopupMenu(context),
        ],
      ),
      body: ListView.builder(
        itemCount: _storageMap.length,
        itemBuilder: _listViewItemBuilder
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleAddition(context),
        child: const Icon(Icons.add),
        backgroundColor: Styles.themeColor
      ),
    );
  }

  Future<void> _loadFiles() async {
    _storageHelper.updateFileState();
    final storageMap = await _storageHelper.storageMap();

    if (mounted) {
      setState(() {
        _storageMap = storageMap;
      });
    }
  }

  Future<void> _updateFiles(BuildContext context) async {
    _loadFiles();

    ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          backgroundColor: Colors.black.withOpacity(0.5),
          content: const Text('Checking for new files...', textAlign: TextAlign.center)
        )
      );
  }

  Widget _renderPopupMenu(BuildContext context) {
    return PopupMenuButton(
      onSelected: (item) => _selectedItem(context, item as int),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.delete, color: Styles.themeColor),
              const SizedBox(width: 7),
              const Text('Delete Local Root Directory')
            ],
          )
        ),
        PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(Icons.logout, color: Styles.themeColor),
              const SizedBox(width: 7),
              const Text('Logout')
            ])
        ),
      ]
    );
  }

  void _selectedItem(BuildContext context, int item) {
    switch (item) {
      case 0: // logout
        _handleLogout(context);
        break;
      case 1: // delete root directory
        _storageHelper.deleteLocalRootDirectory();
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
            onPressed: () => _handleDelete(context, file),
          ),
        )
      );
  }

  Future<void> _handleAddition(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      final List<File> files = result.paths.map((path) => File(path!)).toList();
      final parentDirectories = _storageMap.keys.map((name) => name.split('/').last).toList();

      showPlatformDialog(
        context: context,
        builder: (context) => BasicDialogAlert(
          title: Text('Select a directory in which to store:', style: Styles.textDefault),
          content: SizedBox(
            height: 400.0,
            child: ListView.builder(
              itemCount: parentDirectories.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(parentDirectories[index], style: Styles.textDefault),
                    onTap: () {
                      Navigator.of(context).pop();  
                      _handleStorage(parentDirectories[index], files);
                    },
                  )
                );
              }
            ),
          )
        )
      );
    }
  }

  void _handleStorage(String directory, List<File> files) {
    print(directory);
    print(files);
  }

  void _handleDelete(BuildContext context, StoredItem file) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete "${file.name}"?'),
          actions: [
            TextButton(
              child: Text('Yes', style: Styles.textDefault),
              onPressed: () {
                _storageHelper.deleteFile(file);
                _loadFiles();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No', style: Styles.textDefault),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
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