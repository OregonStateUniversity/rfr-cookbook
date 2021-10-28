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
      _renderButton(context, 'Protocols'),
      _renderButton(context, 'Contacts')
    ];
  }

  Widget _renderButton(BuildContext context, String title) {
    final route = title == 'Protocols' ? ProtocolList(_mockProtocols) : ContactList(_mockContacts);
    return SizedBox(
      height: 200,
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => route
            )
          );
        },
        child: Text(title, style: Styles.buttonText)
      ),
    );
  }

}