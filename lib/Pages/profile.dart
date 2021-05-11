import 'package:eduverse/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String role;
  Future getName() async {
//    String role;
    String name;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser.uid)
        .get()
        .then((value) {
      role = value.data()["role"] + "s";
    });

    var value = await FirebaseFirestore.instance
        .collection(role)
        .doc(_auth.currentUser.uid)
        .get();

    name = value.data()["first_name"] + " " + value.data()["last_name"];
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.1),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text('User Profile', style: TextStyle(fontSize: 20)),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 55,
                    child: Image.asset(
                      "assets/images/avatar.png",
                    )),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: FutureBuilder(
                    future: getName(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                            snapshot.data["first_name"] +
                                " " +
                                snapshot.data["last_name"],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800));
                      } else {
                        return Text('User Name!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800));
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Container(
                    margin: EdgeInsets.fromLTRB(70, 5, 0, 85),
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: kBlue,
                      borderRadius: BorderRadius.circular(13),
                      shape: BoxShape.rectangle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    )),
              ),
            ],
          ),
          FutureBuilder(
              future: getName(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (role == "teachers") {
                    return FacultyProfileCard(
                      email: snapshot.data["email"],
                      branch: snapshot.data["branch"],
                      designation: snapshot.data["designation"],
                      phone: snapshot.data["phone"],
                    );
                  } else {
                    return StudentProfileCard(
                      email: snapshot.data["email"],
                      branch: snapshot.data["branch"],
                      year: snapshot.data["graduating_year"],
                      phone: snapshot.data["phone"],
                      register: snapshot.data["register_number"],
                    );
                  }
                } else
                  return StudentProfileCard(
                      email: "not found",
                      branch: "not found",
                      year: "not found",
                      phone: "not found",
                      register: "not found");
              })
        ],
      ),
    );
  }
}

class StudentProfileCard extends StatelessWidget {
  const StudentProfileCard(
      {this.branch, this.year, this.email, this.phone, this.register});
  final String email;
  final String branch;
  final String year;
  final String phone;
  final String register;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
              child: profileData('Register Number:', register),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
              child: profileData('Email :', email),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: profileData('Branch :', branch),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: profileData('Graduating Year :', year),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: profileData('Phone :', phone),
            )
          ],
        ),
      ),
    );
  }
}

class FacultyProfileCard extends StatelessWidget {
  const FacultyProfileCard(
      {this.branch, this.designation, this.email, this.phone});
  final String email;
  final String branch;
  final String designation;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
              child: profileData('Email :', email),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: profileData('Branch :', branch),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: profileData('Designation :', designation),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: profileData('Phone :', phone),
            )
          ],
        ),
      ),
    );
  }
}

class profileData extends StatelessWidget {
  final String fieldName;
  final String fieldValue;
  profileData(this.fieldName, this.fieldValue);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          fieldName,
          style: TextStyle(color: Colors.grey, fontSize: 17),
        ),
        Text(
          fieldValue,
          style: TextStyle(color: Colors.white, fontSize: 17),
        )
      ],
    );
  }
}
