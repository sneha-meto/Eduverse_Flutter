import 'package:flutter/material.dart';

class Teacher extends StatefulWidget {
  @override
  _TeacherState createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  String _chosenValue;
  String _designation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    height: 50.0,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'First Name',
                        // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Color(0xFF54ABD0), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Color(0xFF54ABD0), width: 2),
                        ),
                      ),
                      // validator: FormValidator().validateEmail,
                      // onSaved: (String value) {
                      //   _loginData.email = value;
                      // },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    height: 50.0,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Last Name',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Color(0xFF54ABD0), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Color(0xFF54ABD0), width: 2),
                        ),
                      ),
                      // validator: FormValidator().validateEmail,
                      // onSaved: (String value) {
                      //   _loginData.email = value;
                      // },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    height: 50.0,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Official Email',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Color(0xFF54ABD0), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Color(0xFF54ABD0), width: 2),
                        ),
                      ),
                      // validator: FormValidator().validateEmail,
                      // onSaved: (String value) {
                      //   _loginData.email = value;
                      // },
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
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 50.0,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Color(0xFF54ABD0), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Color(0xFF54ABD0), width: 2),
                        ),
                      ),
                      // validator: FormValidator().validateEmail,
                      // onSaved: (String value) {
                      //   _loginData.email = value;
                      // },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    height: 50.0,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Color(0xFF54ABD0), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Color(0xFF54ABD0), width: 2),
                        ),
                      ),
                      // validator: FormValidator().validateEmail,
                      // onSaved: (String value) {
                      //   _loginData.email = value;
                      // },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                      onPressed: () {},
                      color: Color(0xFF49C9C4),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Raleway',
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
