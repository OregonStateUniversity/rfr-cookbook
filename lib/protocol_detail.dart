import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'models/protocol.dart';
import 'styles.dart';

class ProtocolDetail extends StatelessWidget {
  final Protocol _protocol;

  const ProtocolDetail(this._protocol, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_protocol.name, style: Styles.navBarTitle)),
      body: _renderBody(_protocol),
    );
  }

  Widget _renderBody(Protocol protocol) {
    return SfPdfViewer.asset(protocol.url);
  }
}