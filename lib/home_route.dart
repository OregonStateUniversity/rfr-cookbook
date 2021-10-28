import 'package:flutter/material.dart';
import 'contact_list.dart';
import 'protocol_list.dart';
import 'mocks/mock_contacts.dart';
import 'mocks/mock_protocols.dart';
import 'styles.dart';

class HomeRoute extends StatelessWidget {
  final _mockContacts = MockContact.fetchAll();
  final _mockProtocols = MockProtocol.fetchAll();

  HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'The Cookbook',
          style: Styles.navBarTitle,
        ),
      ),
      body: _renderBody(context),
    );
  }

  Widget _renderBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _renderChildren(context)
      )
    );
  }

  List<Widget> _renderChildren(BuildContext context) {
    return <Widget>[
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProtocolList(_mockProtocols)
            )
          );
        },
        child: Text('Protocols', style: Styles.buttonText)
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MiscList(_mockContacts)
            )
          );
        },
        child: Text('Contacts', style: Styles.buttonText)
      )
    ];
  }

}