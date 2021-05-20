import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eduverse/Components/chat_name_card.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({
    Key key,
  }) : super(key: key);

  @override
  _GroupsWidgetState createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('group');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Groups',
            style: TextStyle(fontSize: 25),
          ),
          titleSpacing: 0,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: StreamBuilder(
          stream: Constants.myRole == "student"
              ? FirebaseFirestore.instance
                  .collection('groups')
                  .where("branch", isEqualTo: Constants.myBranch)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection('groups')
                  .where("members", arrayContains: _auth.currentUser.uid)
                  .snapshots(),
          builder: (context, userSnapshot) {
            return userSnapshot.hasData
                ? ListView.builder(
                    itemCount: userSnapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.transparent,
                        child: ChatNameCard(
                          name: userSnapshot.data.docs[index]["name"],
                          groupId: userSnapshot.data.docs[index].id,
                          isGroup: true,
                        ),
                      );
                    })
                : Center(child: CircularProgressIndicator());
          },
        ));
  }
}
