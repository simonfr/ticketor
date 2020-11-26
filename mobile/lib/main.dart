import 'package:flutter/material.dart';
import 'package:mobile/Vue/MyHomePage.dart';
import 'dart:async' show Future;

import 'package:mobile/Vue/authentication.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/login': (context) => Authentication(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/': (context) => MyHomePage(),
      },
    );
  }
}
