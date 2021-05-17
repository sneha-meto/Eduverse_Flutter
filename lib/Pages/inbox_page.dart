import 'package:eduverse/Pages/search.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:eduverse/Components/chat_name_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InboxWidget extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inbox',
          style: TextStyle(fontSize: 25),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
          ),
        ],
        titleSpacing: 0,
        elevation: 0,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chats")
              .where("participants", arrayContains: _auth.currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                    color: Colors.transparent,
                    child: ChatNameCard(
                      name: snapshot.data.docs[i].id
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
//                      chatRoomId:
//                          snapshot.data.documents[index].data["chatRoomId"],
                    ),
                  );
                },
              );
            } else
              return Container(child: Text("Inbox empty"));
          }),
    );
  }
}
