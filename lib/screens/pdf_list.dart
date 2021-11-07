import 'package:flutter/material.dart';
import 'package:rfr_cookbook/models/stored_item.dart';
import 'package:rfr_cookbook/styles.dart';
import 'pdf_detail.dart';

class FileList extends StatelessWidget {
  final List<StoredItem> _fileList;
  final String _sectionTitle;

  const FileList(
    this._fileList,
    this._sectionTitle,
    {Key? key}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_sectionTitle, style: Styles.navBarTitle),
        backgroundColor: Styles.navBarColor,
      ),
      body: ListView.builder(
        itemCount: _fileList.length,
        itemBuilder: _listViewItemBuilder,
      ),
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final pdf = _fileList[index];
    return Card(
      child: ListTile(
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        title: Text(pdf.fileName, style: Styles.textDefault),
        onTap: () => _navigationToDetail(context, pdf)
      )
    );
  }

  void _navigationToDetail(BuildContext context, StoredItem file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfDetail(file)
      )
    );
  }

}