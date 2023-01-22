import 'package:flutter/material.dart';
import 'package:smart_municipality/screens/authentification/sign_up.dart';
import 'package:smart_municipality/constants.dart';
import 'package:http/http.dart' as http;
import 'package:smart_municipality/screens/form/form_screen.dart';
import 'package:smart_municipality/screens/home/home_screen.dart';

import 'screens/authentification/sign_in.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fraud App',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignIn(),
    );
  }
}
