import 'package:eduverse/Services/database.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchEditingController = TextEditingController();
  bool isLoading = false;
  bool haveUserSearched = false;
  QuerySnapshot<Map<String, dynamic>> searchResultSnapshot;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseMethods()
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(fontSize: 25),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        elevation: 0,
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              child: TextField(
                                controller: searchEditingController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search users..",
                                  hintStyle: TextStyle(color: Colors.white70),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                              ))),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          initiateSearch();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.search),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient:
                                  LinearGradient(colors: [kPurple, kBlue])),
                        ),
                      )
                    ],
                  ),
                  haveUserSearched
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchResultSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            return userTile(
                              searchResultSnapshot.docs[index].data()["name"],
                            );
                          })
                      : Container()
                ],
              )),
    );
  }

  Widget userTile(String userName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                "detail",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
//              sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: kPurple, borderRadius: BorderRadius.circular(15)),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
