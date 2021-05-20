import 'package:eduverse/Pages/main_page.dart';
import 'package:eduverse/Pages/onboarding.dart';
import 'package:eduverse/Services/database.dart';
import 'package:eduverse/Services/user.dart';
import 'package:flutter/material.dart';
import 'package:eduverse/Components/textbox_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User firebaseUser = FirebaseAuth.instance.currentUser;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var alertStyle = AlertStyle(
    overlayColor: Colors.transparent,
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(60.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Color(0xFF54ABD0),
    ),
  );

  Future saveUserInfo() async {
    await DatabaseMethods()
        .getUserRole(_auth.currentUser.uid)
        .then((userRoleSnapshot) async {
      await DatabaseMethods()
          .getUserInfo(_auth.currentUser.uid, userRoleSnapshot.data()["role"])
          .then((userInfoSnapshot) {
        UserHelper.saveRole(userInfoSnapshot.data()["role"]);
        UserHelper.saveName(userInfoSnapshot.data()["first_name"] +
            " " +
            userInfoSnapshot.data()["last_name"]);
        UserHelper.saveBranch(
            userInfoSnapshot.data()["branch"].toString().toLowerCase());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/bg.png',
                    height: 180,
                  )),
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 90.0,
                        ),
                        Text('EDUVERSE',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 2)),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextBox(
                          textInputType: TextInputType.emailAddress,
                          hint: "Official Email",
                          controller: _emailController,
                        ),
                        TextBox(
                          textInputType: TextInputType.visiblePassword,
                          hint: "Password",
                          controller: _passwordController,
                        ),
                        Button(
                            buttonName: "Sign In",
                            onTap: () async {
                              try {
                                if (_formKey.currentState.validate()) {
                                  User user = (await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ))
                                      .user;
                                  if (user != null) {
                                    await saveUserInfo();
                                    Navigator.of(context).pushReplacement(
                                        new MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (BuildContext context) => HomePage(),
                                    //     ));
                                  }
                                }
                              } catch (e) {
                                print(e);
                                Alert(
                                  context: context,
                                  style: alertStyle,
                                  type: AlertType.info,
                                  title: "Invalid",
                                  desc: "Invalid username or password",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "Close",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      color: Color(0xFF54ABD0),
                                      radius: BorderRadius.circular(10.0),
                                    ),
                                  ],
                                ).show();
                                _emailController.text = "";
                                _passwordController.text = "";
                                // TODO: AlertDialog with error
                              }
                            }),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 10.0),
                          child: Center(
                            child: Container(
                                child: Row(
                              children: <Widget>[
                                Text(
                                  "Don't have an account?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18.0,
                                  ),
                                ),
                                FlatButton(
                                  textColor: Color(0xFF55ACD1),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () async {
                                    //signup screen
                                    var prefs =
                                        await SharedPreferences.getInstance();
                                    var boolKey = 'isFirstTime';
                                    var isFirstTime =
                                        prefs.getBool(boolKey) ?? true;
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              LaunchScreen(prefs, boolKey),
                                        ));
                                  },
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
