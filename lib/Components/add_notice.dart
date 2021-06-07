import 'package:flutter/material.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddNotice extends StatelessWidget {
  String noticeText;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String fName;
  String lName;
  String branch;

  Future getUserDetail() async {
    await FirebaseFirestore.instance
        .collection("teachers")
        .doc(_auth.currentUser.uid)
        .get()
        .then((value) {
      fName = value.data()["first_name"];
      lName = value.data()["last_name"];
      branch = value.data()["branch"].toString().toLowerCase();
    });
  }

  void submitNotice() {
    db.collection("notices").add({
      "branch": branch,
      "created": DateTime.now(),
      "faculty": "$fName $lName",
      "notice": noticeText
    }).then((value) {
      print(value.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
//      height: MediaQuery.of(context).size.height * 0.4,
      height: 330,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
              height: 5,
              width: 35,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Container(
//            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Add to Notice Board",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: TextField(
                      onChanged: (val) {
                        noticeText = val;
                      },
                      maxLength: 300,
                      maxLines: 6,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration.collapsed(
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "Write something.."),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    getUserDetail().then((value) => submitNotice());

                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Center(
                        child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          offset: Offset(1, 1),
                          blurRadius: 4,
                          color: Colors.black54)
                    ], color: kCyan, borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
