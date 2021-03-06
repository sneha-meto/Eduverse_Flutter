import 'package:eduverse/Pages/login.dart';
import 'package:flutter/material.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:eduverse/Pages/teacher_signup.dart';
import 'package:eduverse/Pages/student_signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchScreen extends StatelessWidget {
  final SharedPreferences prefs;
  final String boolKey;
  LaunchScreen(this.prefs, this.boolKey);
  @override
  Widget build(BuildContext context) {
    prefs.setBool(boolKey, false);
    double fullHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0XFF2A2D41),
      body: SafeArea(
        child: Stack(children: [
          Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/images/bg.png',
                height: 180,
              )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Hello !',
                        style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('EDUVERSE',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 22,
                            letterSpacing: 2)),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Pick your role to get started..',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    // Text('Pick your role to get started'),
                  ],
                ),
                SizedBox(height: 30),
                BoxWidget(
                    color: kBlue,
                    image: "assets/images/faculty.png",
                    title: 'Faculty',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Teacher(),
                          ));
                    }),
                SizedBox(
                  height: 30,
                ),
                BoxWidget(
                    color: kPurple,
                    image: "assets/images/student.png",
                    title: 'Student',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Student(),
                          ));
                    }),
                Center(
                  child: Container(
                      child: Row(
                    children: <Widget>[
                      Text(
                        "Already have an account?",
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
                          'Sign In',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Login(),
                              ));
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  )),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class BoxWidget extends StatelessWidget {
  final Color color;
  final String title;
  final String image;
  final Function onTap;
  BoxWidget({this.color, this.title, this.image, this.onTap});
  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 0.5;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
        height: boxWidth,
        width: boxWidth,
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              image,
              color: Colors.white,
              height: 120,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
