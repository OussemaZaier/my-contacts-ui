import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsPage extends StatelessWidget {
  ContactsPage({super.key});

  late final SharedPreferences _prefs;
  late final _prefsFuture =
      SharedPreferences.getInstance().then((v) => _prefs = v);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _prefsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(_prefs.getString('token') ??
                'null'); // `_prefs` is ready for use.
          }

          // `_prefs` is not ready yet, show loading bar till then.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
