import 'package:flutter/material.dart';
import 'models/protocol.dart';
import 'protocol_detail.dart';
import 'styles.dart';

class ProtocolList extends StatelessWidget {
  final List<Protocol> _protocols;

  const ProtocolList(this._protocols, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Protocols', style: Styles.navBarTitle),
        backgroundColor: Styles.navBarColor,
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: _protocols.length,
        itemBuilder: _listViewItemBuilder,
      ),
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final protocol = _protocols[index];
    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      title: _itemTitle(protocol),
      onTap: () => _navigationToProtocolDetail(context, protocol)
    );
  }

  void _navigationToProtocolDetail(BuildContext context, Protocol protocol) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProtocolDetail(protocol)
      )
    );
  }

  Widget _itemTitle(Protocol protocol) {
    return Center(
      child: Text(protocol.name, style: Styles.textDefault)
    );
  }
}