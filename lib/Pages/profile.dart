import 'package:eduverse/Services/database.dart';
import 'package:eduverse/Services/user.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:eduverse/Utils/subjects.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
bool editMode = false;
Map<String, String> info = {
  'Register Number': "",
  'Branch': Constants.myBranch.toUpperCase(),
  'Graduating Year': "",
  'Phone': "",
  'Designation': "",
};

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String roleCollection;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  Future getName() async {
    var userRoleSnapshot =
        await DatabaseMethods().getUserRole(_auth.currentUser.uid);
    roleCollection = userRoleSnapshot.data()["role"] + "s";

    return await DatabaseMethods()
        .getUserInfo(_auth.currentUser.uid, userRoleSnapshot.data()["role"]);
  }

  saveEdit() async {
    if (Constants.myRole == "teacher") {
      Map<String, dynamic> user = {
        'branch': info['Branch'],
        'designation': info['Designation'],
        'phone': info['Phone'],
      };

      await DatabaseMethods()
          .updateUser("teachers", _auth.currentUser.uid, user);
    } else {
      Map<String, dynamic> user = {
        'branch': info['Branch'],
        'register_number': info['Register Number'],
        'graduating_year': info['Graduating Year'],
        'phone': info['Phone'],
      };
      await DatabaseMethods()
          .updateUser("students", _auth.currentUser.uid, user);
    }

    if (Constants.myRole == "teacher") {
      await DatabaseMethods()
          .removeFromOfficialGroup(Constants.myBranch, _auth.currentUser.uid);
      await DatabaseMethods().addToOfficialGroup(
          info['Branch'].toLowerCase(), _auth.currentUser.uid);
    }
    await UserHelper.saveName(info['First Name'] + " " + info['Last Name']);
    print(info['Branch']);
    await UserHelper.saveBranch(info['Branch'].toLowerCase());
    Constants.myName = await UserHelper.getName();
    Constants.myBranch = await UserHelper.getBranch();
  }

  @override
  void initState() {
    super.initState();
    firstNameController.text = Constants.myName.split(" ")[0];
    lastNameController.text = Constants.myName.split(" ")[1];
    info["First Name"] = Constants.myName.split(" ")[0];
    info["Last Name"] = Constants.myName.split(" ")[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.1),
        leading: IconButton(
            onPressed: () {
              editMode = false;
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text('User Profile', style: TextStyle(fontSize: 25)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 55,
                      child: Image.asset(
                        "assets/images/avatar.png",
                      )),
                ),
                Expanded(
                  child: Text(Constants.myName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                ),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Column(
                    children: [
                      Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: kBlue,
                            borderRadius: BorderRadius.circular(13),
                            shape: BoxShape.rectangle,
                          ),
                          child: InkWell(
                            onTap: () {
                              if (editMode) {
                                saveEdit();
                              }

                              setState(() {
                                editMode = !editMode;
                              });
                            },
                            child: Icon(
                              editMode ? Icons.save : Icons.edit,
                              color: Colors.white,
                            ),
                          )),
                      SizedBox(height: 20),
                      editMode
                          ? Container(
//                      margin: EdgeInsets.fromLTRB(70, 5, 0, 85),
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: kPurple,
                                borderRadius: BorderRadius.circular(13),
                                shape: BoxShape.rectangle,
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    editMode = !editMode;
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ))
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
            FutureBuilder(
                future: getName(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (roleCollection == "teachers") {
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
                    return Center(child: Text("no data found"));
                })
          ],
        ),
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
              child: ProfileData('Register Number', register),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
              child: ProfileData('Email', email),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ProfileData('Branch', branch),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ProfileData('Graduating Year', year),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ProfileData('Phone', phone),
            )
          ],
        ),
      ),
    );
  }
}

class FacultyProfileCard extends StatelessWidget {
  FacultyProfileCard({this.branch, this.designation, this.email, this.phone});
  final String email;
  final String branch;
  final String designation;
  final String phone;
  final List subjectList = subjects.keys.toList();
  List<int> selectedItems = <int>[];
  List selectedSubs = [];
  var items = subjects.values.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem(
      value: value,
      child: Text(
        value,
        style: TextStyle(color: Colors.white),
      ),
    );
  }).toList();

  List selectSubjects(value) {
    value.forEach((element) {
      selectedSubs.add(subjectList[element]);
    });
    return selectedSubs;
  }

  Future addSubject(value) async {
    await FirebaseFirestore.instance
        .collection("teachers")
        .doc(_auth.currentUser.uid)
        .update({
      "subjects": FieldValue.arrayUnion(selectSubjects(value))
    }).then((value) => print("subjects added"));
  }

  Future addToGroup(value) async {
    selectSubjects(value).forEach((element) async {
      await FirebaseFirestore.instance
          .collection("groups")
          .doc(element)
          .update({
        "members": FieldValue.arrayUnion([_auth.currentUser.uid])
      }).then((value) => print("member added"));
    });
  }

  Future removeFromGroup(value) async {
    selectSubjects(value).forEach((element) async {
      await FirebaseFirestore.instance
          .collection("groups")
          .doc(element)
          .update({
        "members": FieldValue.arrayRemove([_auth.currentUser.uid])
      }).then((value) => print("member removed"));
    });
  }

  Future clearSubjects() async {
    await FirebaseFirestore.instance
        .collection("teachers")
        .doc(_auth.currentUser.uid)
        .update({"subjects": []}).then((value) => print("subjects deleted"));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
                  child: ProfileData('Email', email),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ProfileData('Branch', branch),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ProfileData('Designation', designation),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ProfileData('Phone', phone),
                )
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Subjects",
                    style: TextStyle(color: Colors.grey, fontSize: 17),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("teachers")
                          .doc(_auth.currentUser.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data["subjects"] != null) {
                            print(snapshot.data["subjects"]);
                            selectedSubs = snapshot.data["subjects"];

                            selectedSubs.forEach((element) {
                              if (!selectedItems
                                  .contains(subjectList.indexOf(element))) {
                                selectedItems.add(subjectList.indexOf(element));
                              }
                            });
                          }

                          return SearchableDropdown.multiple(
                            items: items,
                            selectedItems: selectedItems,
                            onChanged: (value) {
//                              selectedItems = value;
                              addSubject(value);
                              addToGroup(value);
                            },
                            onClear: () {
                              removeFromGroup(selectedItems);
                              selectedItems.clear();
                              clearSubjects();
                            },
                            isExpanded: true,
                            hint: Text(
                              "Add subject..",
                              style: TextStyle(color: Colors.grey),
                            ),
                            menuBackgroundColor: kScaffold,
                          );
                        } else
                          return Container();
                      })
                ],
              ))
        ],
      ),
    );
  }
}

class ProfileData extends StatefulWidget {
  final String fieldName;
  final String fieldValue;
  ProfileData(this.fieldName, this.fieldValue);

  @override
  _ProfileDataState createState() => _ProfileDataState();
}

class _ProfileDataState extends State<ProfileData> {
  TextEditingController textEditingController = TextEditingController();
  List<String> branchList = [
    'IT',
    'CS',
    'EC',
  ];

  List<String> designationList = [
    'HOD',
    'Professor',
    'Associate Professor',
    'Assistant Professor',
    'Guest Lecturer'
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      textEditingController.text = widget.fieldValue;
//      if (widget.fieldName != 'Branch' && widget.fieldName != 'Designation') {
      info[widget.fieldName] = widget.fieldValue;
//      }
    });
  }

  String validate(String value, String type) {
    if (value.isEmpty) {
      return 'This field is required';
    }

    switch (type) {
      case "Graduating Year":
        if (int.parse(value) < 2021 || int.parse(value) > 2031) {
          return 'Please enter a valid year';
        }
        break;

      case "Register Number":
        if (value.length != 8) {
          return 'Register number should be 8 digits long';
        }
        break;

      case "Phone":
        if (value.length != 10) {
          return 'Phone number should be 10 digits long';
        }
        break;

      case "Designation":
        Pattern pattern =
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?)*$";
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value) || value == null)
          return 'Enter a valid email address';
        break;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.fieldName + " :",
          style: TextStyle(color: Colors.grey, fontSize: 17),
        ),
        editMode
            ? widget.fieldName == 'Branch' || widget.fieldName == 'Designation'
                ? DropdownButton<String>(
                    onChanged: (String value) {
                      setState(() {
                        widget.fieldName == 'Branch'
                            ? info['Branch'] = value
                            : info['Designation'] = value;
                      });
                    },
                    value: info[widget.fieldName],
                    style: TextStyle(
                      color: Color(0xFFAAABB3),
                    ),
                    items: widget.fieldName == 'Branch'
                        ? branchList
                            .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()
                        : designationList
                            .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList())
                : widget.fieldName == "Email"
                    ? Text(
                        widget.fieldValue,
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )
                    : Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            validator: (value) {
                              String result = validate(value, widget.fieldName);
                              return result;
                            },
                            controller: textEditingController,
                            onChanged: (val) {
                              info[widget.fieldName] = val;
                            },
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
            : Text(
                widget.fieldValue,
                style: TextStyle(color: Colors.white, fontSize: 17),
              )
      ],
    );
  }
}
