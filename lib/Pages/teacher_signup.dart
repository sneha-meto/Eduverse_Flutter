import 'package:flutter/material.dart';
import 'package:eduverse/Components/textandbutton.dart';
import 'package:eduverse/Pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  List<String> _subjects = [];

  String _chosenValue;
  String _designation;
  bool _success;
  String _userEmail = '';
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
                          controller: _firstname,
                        ),
                        TextBox(
                          textInputType: TextInputType.name,
                          hint: "Last Name",
                          controller: _lastname,
                        ),
                        TextBox(
                          textInputType: TextInputType.emailAddress,
                          hint: "Official Email",
                          controller: _emailController,
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
                          controller: _phone,
                        ),
                        TextBox(
                          textInputType: TextInputType.visiblePassword,
                          hint: "Password",
                          controller: _passwordController,
                        ),
                        Button(
                            buttonName: "Sign Up",
                            onTap: () async{

                              if (_formKey.currentState.validate()) {
                                await _register();
                                print(_auth.currentUser.uid);


                                final firestoreInstance = FirebaseFirestore.instance;
                                firestoreInstance.collection("teachers").doc(_auth.currentUser.uid).set(
                                    {
                                      'first_name': _firstname.text,
                                      'last_name': _lastname.text,
                                      'email' : _emailController.text,
                                      'branch' : _chosenValue,
                                      'designation' : _designation,
                                      'phone' : _phone.text,
                                      'password' : _passwordController.text,
                                      'role' : "teacher",
                                      'subjects' : _subjects,
                                    }).then((_){
                                  print("success!");
                                });

                                firestoreInstance.collection("users").doc(_auth.currentUser.uid).set(
                                    {

                                      'role' : "teacher",
                                    }).then((_){
                                  print("users success!");
                                });

                                Navigator.of(context).pushReplacement(
                                    new MaterialPageRoute(builder: (context) => HomePage()));

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (BuildContext context) => HomePage(),
                                //     ));
                              }
                            }),
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
