import 'dart:convert';

import 'package:contacts_flutter/utils/get_token.dart';
import 'package:contacts_flutter/view_models/login_view_model.dart';
import 'package:contacts_flutter/views/contacts_page.dart';
import 'package:contacts_flutter/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

void main() async {
  //necessary for reading theme data
  WidgetsFlutterBinding.ensureInitialized();

  //reading light theme data
  final themeStr = await rootBundle.loadString('assets/theme/light.json');
  final themeJson = jsonDecode(themeStr);
  final lightTheme = ThemeDecoder.decodeThemeData(themeJson)!;

  //reading dark theme data
  final darkThemeStr = await rootBundle.loadString('assets/theme/dark.json');
  final darkThemeJson = jsonDecode(darkThemeStr);
  final darkTheme = ThemeDecoder.decodeThemeData(darkThemeJson)!;

  //runnning APP
  runApp(
    //using multiProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: HomePage(
        lightTheme: lightTheme,
        darkTheme: darkTheme,
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
    required this.lightTheme,
    required this.darkTheme,
  });

  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final _token = Token();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: darkTheme,
        // home: const LoginPage(
        //   isSignUp: true,
        // ),
        home: FutureBuilder<String?>(
          future: _token.getToken,
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: RiveAnimation.asset('assets/rive/loading.riv'),
              );
            } else if (snapshot.hasData) {
              // There is a Token instance in the local storage

              return FutureBuilder<void>(
                future: context
                    .read<LoginViewModel>()
                    .verifyToken(snapshot.data.toString()),
                builder: (BuildContext context,
                    AsyncSnapshot<void> verifyTokenSnapshot) {
                  if (verifyTokenSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Scaffold(
                      body: RiveAnimation.asset('assets/rive/loading.riv'),
                    );
                  } else {
                    final isTokenValid =
                        context.read<LoginViewModel>().res != null;
                    return isTokenValid ? ContactsPage() : const LoginPage();
                  }
                },
              );
            } else {
              return const Scaffold(
                body: RiveAnimation.asset('assets/rive/loading.riv'),
              );
            }
          },
        ));
  }
}
