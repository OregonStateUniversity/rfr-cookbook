import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/contact.dart';
import 'styles.dart';

class ContactList extends StatelessWidget {
  final List<Contact> _contacts;

  const ContactList(this._contacts, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacts',
          style: Styles.navBarTitle,
        )
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: _contacts.length,
        itemBuilder: _listViewItemBuilder,
      ),
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final contact = _contacts[index];
    return ListTile(
      title: _itemTitle(contact),
      onTap: () => _launchURL('tel:' + contact.number),
    );
  }

  void _launchURL(String url) async => 
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  Widget _itemTitle(Contact contact) {
    return Text(
      contact.name + ' : ' + contact.number,
      style: Styles.textDefault,
    );
  }
}