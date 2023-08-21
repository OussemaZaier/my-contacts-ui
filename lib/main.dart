import 'package:contacts_flutter/view_models/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: InkWell(
            onTap: () => context.read<LoginViewModel>().login('ouss', 'ouss'),
            child: Container(
              width: 200,
              height: 200,
              color: Colors.green,
              key: const Key('keyText'),
              child: Text('${context.watch<LoginViewModel>().res?.message}'),
            ),
          ),
        ),
      ),
    );
  }
}
