import 'package:flutter/material.dart';
import 'models/contact.dart';
import 'styles.dart';

class MiscList extends StatelessWidget {
  final List<Contact> _contacts;

  const MiscList(this._contacts, {Key? key}) : super(key: key);

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
      contentPadding: const EdgeInsets.all(10),
      title: _itemTitle(contact),
    );
  }

  Widget _itemTitle(Contact contact) {
    return Center(
      child: Text(
        contact.name + ' : ' + contact.number,
        style: Styles.textDefault,
      )
    );
  }
}