import 'package:flutter/material.dart';
import 'package:eduverse/Pages/main_page.dart';
import 'package:eduverse/Pages/onboarding.dart';
import 'package:eduverse/Pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Pages/login.dart';
import 'Pages/main_page.dart';
import 'Pages/onboarding.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
  // var isLoggedIn = (prefs.getBool('isLoggedIn') == null) ??    true;
  var boolKey = 'isFirstTime';
  var isFirstTime = prefs.getBool(boolKey) ?? true;
  await Firebase.initializeApp();

  runApp(MaterialApp(
    title: 'Eduverse',
    theme: ThemeData(
      fontFamily: "Roboto",
      appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: Color(0xff2A2D41),
      primarySwatch: Colors.blue,
    ),
    home: isFirstTime
        ? LaunchScreen(prefs, boolKey)
        : DevicePreview(
//      enabled: !kReleaseMode,
            enabled: false,
            builder: (context) => MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
      User firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        /// is because there is user already logged
        return HomePage();
      } else {
        /// other way there is no user logged.
        return Login();
      }
    });
  }
}
