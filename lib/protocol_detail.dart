import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'models/protocol.dart';
import 'styles.dart';

class ProtocolDetail extends StatelessWidget {
  final Protocol protocol;

  const ProtocolDetail(this.protocol, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(protocol.name, style: Styles.navBarTitle)),
      body: _renderBody(context, protocol),
    );
  }

  Widget _renderBody(BuildContext context, Protocol protocol) {
    return SfPdfViewer.asset(protocol.url);
  }
}