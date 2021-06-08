import 'package:eduverse/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:eduverse/Components/textbox_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_page.dart';
import 'package:eduverse/Services/user.dart';

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
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Faculty Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0,
                                    ),
                                  ),
                                  Text(
                                    "Let's get you started on your \nbrand new faculty account!",
                                    style: TextStyle(
                                      color: Colors.white70,
//                                  fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              "EDUVERSE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 22,
                                  letterSpacing: 2),
                            ),
                          ),
                        ),
                        TextBox(
                          textInputType: TextInputType.name,
                          hint: "First Name",
                          controller: _firstname,
                          fieldName: "firstName",
                        ),
                        TextBox(
                          textInputType: TextInputType.name,
                          hint: "Last Name",
                          controller: _lastname,
                          fieldName: "lastName",
                        ),
                        TextBox(
                          textInputType: TextInputType.emailAddress,
                          hint: "Official Email",
                          controller: _emailController,
                          fieldName: "email",
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: _chosenValue,
                              //elevation: 5,
                              style: TextStyle(
                                color: Color(0xFFAAABB3),
                              ),

                              items: <String>[
                                'IT',
                                'CS',
                                'EC',
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
                                  fontSize: 17, // fontWeight: FontWeight.w600
                                ),
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF54ABD0),
                                    width: 2,
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF54ABD0),
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF54ABD0),
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFF54ABD0), width: 2),
                                ),
                              ),
                              onChanged: (String value) =>
                                  setState(() => _chosenValue = value),
                              validator: (value) => value == null
                                  ? 'This field is required'
                                  : null,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
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
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF54ABD0),
                                    width: 2,
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF54ABD0),
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF54ABD0),
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFF54ABD0), width: 2),
                                ),
                              ),
                              onChanged: (String value) =>
                                  setState(() => _designation = value),
                              validator: (value) => value == null
                                  ? 'This field is required'
                                  : null,
                            ),
                          ),
                        ),
                        TextBox(
                          textInputType: TextInputType.number,
                          hint: "Phone Number",
                          controller: _phone,
                          fieldName: "phone",
                        ),
                        TextBox(
                          textInputType: TextInputType.visiblePassword,
                          hint: "Password",
                          controller: _passwordController,
                          fieldName: "password",
                        ),
                        Button(
                            buttonName: "Sign Up",
                            onTap: () async {
                              if (_formKey.currentState.validate()) {
                                await _register();
                                print(_auth.currentUser.uid);

                                final firestoreInstance =
                                    FirebaseFirestore.instance;
                                firestoreInstance
                                    .collection("teachers")
                                    .doc(_auth.currentUser.uid)
                                    .set({
                                  'first_name': _firstname.text,
                                  'last_name': _lastname.text,
                                  'email': _emailController.text,
                                  'branch': _chosenValue,
                                  'designation': _designation,
                                  'phone': _phone.text,
                                  'password': _passwordController.text,
                                  'role': "teacher",
                                  'subjects': _subjects,
                                }).then((_) {
                                  print("success!");
                                });

                                firestoreInstance
                                    .collection("users")
                                    .doc(_auth.currentUser.uid)
                                    .set({
                                  'role': "teacher",
                                  'name':
                                      _firstname.text + " " + _lastname.text,
                                }).then((_) {
                                  print("users success!");
                                });
                                UserHelper.saveName(
                                    _firstname.text + " " + _lastname.text);
                                UserHelper.saveRole("teacher");
                                UserHelper.saveBranch(
                                    _chosenValue.toLowerCase());
                                DatabaseMethods().addToOfficialGroup(
                                    _chosenValue.toLowerCase(),
                                    _auth.currentUser.uid);

                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));

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
