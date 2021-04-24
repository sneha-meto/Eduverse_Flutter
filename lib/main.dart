import 'package:flutter/material.dart';
import 'package:eduverse/Pages/main_page.dart';
import 'package:eduverse/Pages/onboarding.dart';
import 'package:eduverse/Pages/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eduverse',
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        scaffoldBackgroundColor: Color(0xff2A2D41),
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
