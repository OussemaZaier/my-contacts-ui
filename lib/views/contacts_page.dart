import 'package:azlistview/azlistview.dart';
import 'package:contacts_flutter/utils/get_token.dart';
import 'package:flutter/material.dart';

import '../models/contact_model.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final _token = Token();
  //Contact data
  final List<Contact> _contacts = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() {
    for (var i = 0; i < 10; i++) {
      _contacts.add(
        Contact(
            id: i.toString(),
            userId: i.toString(),
            name: 'auser $i',
            email: 'email_user$i@email.tn',
            phone: '25117179'),
      );
    }
    for (var i = 0; i < 10; i++) {
      _contacts.add(
        Contact(
            id: i.toString(),
            userId: i.toString(),
            name: 'zuser $i',
            email: 'email_user$i@email.tn',
            phone: '25117179'),
      );
    }
    for (var i = 0; i < 10; i++) {
      _contacts.add(
        Contact(
            id: i.toString(),
            userId: i.toString(),
            name: 'xuser $i',
            email: 'email_user$i@email.tn',
            phone: '25117179'),
      );
    }
    for (var i = 0; i < 10; i++) {
      _contacts.add(
        Contact(
            id: i.toString(),
            userId: i.toString(),
            name: 'user $i',
            email: 'email_user$i@email.tn',
            phone: '25117179'),
      );
    }
    print(_contacts[0].tag);
    // _handleList(_contacts);
  }

  void _handleList(List<Contact> list) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _token.getToken,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AzListView(
                data: _contacts,
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return _buildContact(contact);
                }); // `_prefs` is ready for use.
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _buildContact(Contact contact) => ListTile(
        title: Text(contact.name),
      );
}
