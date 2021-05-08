import 'package:eduverse/Pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:eduverse/Components/textandbutton.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: ListView(
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
                      child: Text("Welcome Back!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 36.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      "EDUVERSE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 70.0,
                ),
                TextBox(
                  textInputType: TextInputType.emailAddress,
                  hint: "Official Email",
                ),

                TextBox(
                  textInputType: TextInputType.visiblePassword,
                  hint: "Password",
                ),

                Button(
                    buttonName: "Sign In",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => HomePage(),
                          ));
                    }
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}