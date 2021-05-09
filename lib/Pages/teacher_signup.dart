import 'package:flutter/material.dart';
import 'package:eduverse/Components/textandbutton.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'main_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Teacher extends StatefulWidget {
  @override
  _TeacherState createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _chosenValue;
  String _designation;
  bool _success;
  String _userEmail = '';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Hello!",
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
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        "EDUVERSE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0,
                        ),
                      ),
                    ),
                  ),
                  TextBox(
                    textInputType: TextInputType.name,
                    hint: "First Name",
                  ),
                  TextBox(
                    textInputType: TextInputType.name,
                    hint: "Last Name",
                  ),
                  TextBox(
                    textInputType: TextInputType.emailAddress,
                    hint: "Official Email",
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Color(0xFF54ABD0), width: 2),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15.0, right: 3.0, top: 3.0, bottom: 3.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _chosenValue,
                            //elevation: 5,
                            style: TextStyle(
                              color: Color(0xFFAAABB3),
                            ),

                            items: <String>[
                              'IT',
                              'CS',
                              'CIVIL',
                              'MECHANICAL',
                              'FIRE & SAFETY',
                              'ELECTRICAL',
                              'ELECTRONICS',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            hint: Text(
                              "Branch",
                              style: TextStyle(
                                color: Color(0xFFAAABB3),
                                fontSize: 17,
                                // fontWeight: FontWeight.w600
                              ),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                _chosenValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Color(0xFF54ABD0), width: 2),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15.0, right: 3.0, top: 3.0, bottom: 3.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _designation,
                            //elevation: 5,
                            style: TextStyle(
                              color: Color(0xFFAAABB3),
                            ),

                            items: <String>[
                              'HOD',
                              'Professor',
                              'Associate Professor',
                              'Assistant Professor',
                              'Guest Lecturer',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            hint: Text(
                              "Designation",
                              style: TextStyle(
                                color: Color(0xFFAAABB3),
                                fontSize: 17,
                                // fontWeight: FontWeight.w600
                              ),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                _designation = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextBox(
                    textInputType: TextInputType.number,
                    hint: "Phone Number",
                  ),
                  TextBox(
                    textInputType: TextInputType.visiblePassword,
                    hint: "Password",
                  ),
                  Button(
                      buttonName: "Sign Up",
                      onTap: () async {
                        if (_formKey.currentState.validate()) {
                          await _register();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => HomePage(),
                              ));
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code for registration.
  Future<void> _register() async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      _success = false;
    }
  }
}
