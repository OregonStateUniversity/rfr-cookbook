import 'dart:io';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rfr_cookbook/models/stored_item.dart';
import 'package:rfr_cookbook/storage_helper.dart';
import 'package:rfr_cookbook/config/styles.dart';
import 'package:rfr_cookbook/utils/snackbar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rfr_cookbook/widgets/app_bar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _storageHelper = StorageHelper();
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Admin Panel', actions: [
        IconButton(
            onPressed: () => _loadFiles(), icon: const Icon(Icons.refresh)),
        IconButton(
          onPressed: () => _handleLogout(context),
          icon: const Icon(Icons.logout),
        )
      ]),
      body: ListView.builder(
          itemCount: _storageHelper.localStorageMap.length,
          itemBuilder: _listViewItemBuilder),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        spacing: 10,
        spaceBetweenChildren: 12,
        backgroundColor: Styles.themeColor,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.delete),
            label: 'Delete Directory',
            onTap: () => _renderDirectoryDeleter(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.folder),
            label: 'Create Directory',
            onTap: () => _renderDirectoryAdder(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.file_copy),
            label: 'Add File',
            onTap: () => _handleFileAddition(context),
          ),
        ],
      ),
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final targetDirectory = _storageHelper.localStorageMap.keys.toList()[index];
    final directoryName = targetDirectory.split('/').last;
    final fileList = _storageHelper.localStorageMap[targetDirectory];
    return Card(
        child: ExpansionTile(
      title: Text(directoryName, style: Styles.textDefault),
      children: _buildExpandableContent(context, fileList!),
    ));
  }

  List<Widget> _buildExpandableContent(
      BuildContext context, List<StoredItem> list) {
    return list
        .map((file) => Card(
            child: ListTile(
                title: Text(file.name, style: Styles.textDefault),
                trailing: _renderPopupMenu(context, file))))
        .toList();
  }

  Future<void> _loadFiles() async {
    EasyLoading.show(status: 'Updating files...');
    await _storageHelper.refreshFileState();
    await _storageHelper.updateLocalStorageMap();
    await EasyLoading.dismiss();

    if (mounted) {
      setState(() {});
    }
  }

  Widget _renderPopupMenu(BuildContext context, StoredItem file) {
    return PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        onSelected: (item) => _selectedItem(context, file, item as int),
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: 0,
                  child: Row(children: [
                    Icon(Icons.delete, color: Styles.themeColor),
                    const SizedBox(width: 7),
                    const Text('Delete')
                  ])),
              PopupMenuItem(
                  value: 1,
                  child: Row(children: [
                    Icon(Icons.preview, color: Styles.themeColor),
                    const SizedBox(width: 7),
                    const Text('View')
                  ]))
            ]);
  }

  void _selectedItem(BuildContext context, StoredItem file, int item) {
    switch (item) {
      case 0: // delete
        _handleDelete(context, file);
        break;
      case 1: // preview
        _handlePreview(context, file);
        break;
      default:
    }
  }

  void _handleDelete(BuildContext context, StoredItem file) {
    showPlatformDialog(
        context: context,
        builder: (context) => BasicDialogAlert(
              title: Text('Delete "${file.name}"?'),
              actions: [
                BasicDialogAction(
                  title: Text('Yes', style: Styles.textDefault),
                  onPressed: () async {
                    await _storageHelper.deleteFile(file);
                    Navigator.of(context).pop();
                    _loadFiles();
                  },
                ),
                BasicDialogAction(
                  title: Text('No', style: Styles.textDefault),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }

  void _handlePreview(BuildContext context, StoredItem file) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: appBar(title: file.name),
              body: SfPdfViewer.file(file.localFile),
            )));
  }

  void _renderDirectoryDeleter(BuildContext context) {
    final parentDirectories = _storageHelper.localStorageMap.keys
        .map((name) => name.split('/').last)
        .toList();

    showPlatformDialog(
        context: context,
        builder: (context) => BasicDialogAlert(
                actions: [
                  BasicDialogAction(
                    title: Text('Cancel', style: Styles.textDefault),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                title: Text('Select a directory to delete:',
                    style: Styles.textDefault),
                content: SizedBox(
                  width: double.maxFinite,
                  height: 400.0,
                  child: ListView.builder(
                      itemCount: parentDirectories.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: ListTile(
                          title: Text(parentDirectories[index],
                              style: Styles.textDefault),
                          onTap: () {
                            Navigator.of(context).pop();
                            showPlatformDialog(
                                context: context,
                                builder: (context) => BasicDialogAlert(
                                      title: Text(
                                          'Delete "${parentDirectories[index]}" and all its contents?'),
                                      actions: [
                                        BasicDialogAction(
                                          title: Text('Yes',
                                              style: Styles.textDefault),
                                          onPressed: () async {
                                            await _storageHelper
                                                .deleteDirectory(
                                                    parentDirectories[index]);
                                            Navigator.of(context).pop();
                                            _loadFiles();
                                          },
                                        ),
                                        BasicDialogAction(
                                          title: Text('No',
                                              style: Styles.textDefault),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        )
                                      ],
                                    ));
                          },
                        ));
                      }),
                )));
  }

  void _renderDirectoryAdder(BuildContext context) {
    showPlatformDialog(
        context: context,
        builder: (context) => BasicDialogAlert(
              actions: [
                BasicDialogAction(
                    title: Text('Cancel', style: Styles.textDefault),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _textController.clear();
                    }),
                BasicDialogAction(
                  title: Text('Ok', style: Styles.textDefault),
                  onPressed: () async {
                    await _storageHelper.createDirectory(_textController.text);
                    _textController.clear();
                    Navigator.of(context).pop();
                    _loadFiles();
                  },
                )
              ],
              title:
                  Text('Enter name of directory:', style: Styles.textDefault),
              content: SizedBox(
                  child:
                      Material(child: TextField(controller: _textController))),
            ));
  }

  Future<void> _handleFileAddition(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      final List<File> files = result.paths.map((path) => File(path!)).toList();
      final parentDirectories = _storageHelper.localStorageMap.keys
          .map((name) => name.split('/').last)
          .toList();

      showPlatformDialog(
          context: context,
          builder: (context) => BasicDialogAlert(
                  actions: [
                    BasicDialogAction(
                      title: Text('Cancel', style: Styles.textDefault),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                  title: Text('Select a directory in which to store:',
                      style: Styles.textDefault),
                  content: SizedBox(
                    width: double.maxFinite,
                    height: 400.0,
                    child: ListView.builder(
                        itemCount: parentDirectories.length,
                        itemBuilder: (context, index) {
                          return Card(
                              child: ListTile(
                            title: Text(parentDirectories[index],
                                style: Styles.textDefault),
                            onTap: () {
                              _handleStorage(
                                  context, parentDirectories[index], files);
                              Navigator.of(context).pop();
                            },
                          ));
                        }),
                  )));
    }
  }

  void _handleStorage(
      BuildContext context, String directory, List<File> files) {
    for (final file in files) {
      final fileName = file.path.split('/').last;
      _storageHelper.uploadFile(file, '/protocols/$directory/$fileName');
    }

    displaySnackbar(context, 'Uploading to server...');
  }

  void _handleLogout(BuildContext context) {
    showPlatformDialog(
        context: context,
        builder: (context) => BasicDialogAlert(
              title: Text('Are you sure you want to log out?',
                  style: Styles.textDefault),
              actions: [
                BasicDialogAction(
                  title: Text('Yes', style: Styles.textDefault),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    displaySnackbar(context, 'You have been logged out.');
                  },
                ),
                BasicDialogAction(
                  title: Text('No', style: Styles.textDefault),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }
}
