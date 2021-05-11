import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eduverse/Pages/main_page.dart';
import 'package:eduverse/Pages/onboarding.dart';
import 'package:eduverse/Pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DevicePreview(
//      enabled: !kReleaseMode,
      enabled: false,
      builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eduverse',
      theme: ThemeData(
        fontFamily: "Roboto",
        appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        scaffoldBackgroundColor: Color(0xff2A2D41),
        primarySwatch: Colors.blue,
      ),
      home: LaunchScreen(),
    );
  }
}
