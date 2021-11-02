import 'package:flutter/material.dart';
import 'models/pdf.dart';
import 'pdf_detail.dart';
import 'styles.dart';

class PdfList extends StatelessWidget {
  final List<Pdf> _pdfList;
  final String _sectionTitle;

  const PdfList(
    this._pdfList,
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
        itemCount: _pdfList.length,
        itemBuilder: _listViewItemBuilder,
      ),
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final pdf = _pdfList[index];
    return Card(
      child: ListTile(
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        title: Text(pdf.title, style: Styles.textDefault),
        onTap: () => _navigationToProtocolDetail(context, pdf)
      )
    );
  }

  void _navigationToProtocolDetail(BuildContext context, Pdf pdf) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfDetail(pdf)
      )
    );
  }

}