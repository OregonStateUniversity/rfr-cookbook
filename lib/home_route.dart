import 'package:flutter/material.dart';
import 'contact_detail.dart';
import 'protocol_list.dart';
import 'mocks/mock_protocols.dart';
import 'styles.dart';

class HomeRoute extends StatelessWidget {
  final _mockProtocols = MockProtocol.fetchAll();

  HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('theCookbook', style: Styles.navBarTitle),
        backgroundColor: Styles.navBarColor,
        //probably need to move this somewhere so we can use it on every page
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            iconSize: 42,
            //tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a hamburger menu')));
            },
          ),
        ],
      ),
      body: _renderBody(context),
    );
  }

  Widget _renderBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _renderButton(context, 'Protocols'),
          _renderButton(context, 'Contacts')
        ]
      )
    );
  }

  Widget _renderButton(BuildContext context, String title) {
    final route = title == 'Protocols' ? ProtocolList(_mockProtocols) : const ContactDetail();
    return SizedBox(
      height: 200,
      width: 200,
      child: ElevatedButton(
        style: Styles.buttonStyle,
        child: Text(title, style: Styles.buttonText),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => route
            )
          );
        },
      ),
    );
  }
}