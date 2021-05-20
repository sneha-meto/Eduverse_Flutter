import 'package:eduverse/Pages/profile.dart';
import 'package:eduverse/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:eduverse/Components/add_notice.dart';
import 'package:eduverse/Components/add_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:eduverse/Utils/subjects.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eduverse/Pages/login.dart';
import 'package:eduverse/Components/home_tiles.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class HomeWidget extends StatelessWidget {
  String getDay() {
    var day =
        DateFormat('EEEE').format(DateTime.now()).toLowerCase().substring(0, 3);
    print(day);
    if (day == "sat" || day == "sun")
      return "mon";
    else
      return day;
  }

  Future getUser() async {
    var userRoleSnapshot =
        await DatabaseMethods().getUserRole(_auth.currentUser.uid);
    return await DatabaseMethods()
        .getUserInfo(_auth.currentUser.uid, userRoleSnapshot.data()["role"]);
  }

  Future getRole() async {
    var value = await DatabaseMethods().getUserRole(_auth.currentUser.uid);
    var role = value.data()["role"];
    return role;
  }

  @override
  Widget build(BuildContext context) {
    getDay();

    return SingleChildScrollView(
      child: Column(children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
              child: CircleAvatar(
                child: Image.asset(
                  "assets/images/avatar.png",
                ),
                radius: 50,
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            FutureBuilder(
              future: getUser(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Text('Hi ${snapshot.data["first_name"]}!',
                      style: TextStyle(color: Colors.white, fontSize: 30));
                }
                return Text('Hi User!',
                    style: TextStyle(color: Colors.white, fontSize: 30));
              },
            ),
            Expanded(
              child: IconButton(
                  alignment: Alignment.centerRight,
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Future<void> _signOut() async {
                      print("success  signoff ");
                      return _auth.signOut();
                    }

                    _signOut();

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Login(),
                        ));
                  }),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        DefaultTabController(
            length: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: TabBar(
                      unselectedLabelColor: Colors.black45,
                      overlayColor: null,
                      enableFeedback: false,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BubbleTabIndicator(
                          indicatorHeight: 100.0,
                          indicatorColor: Colors.white.withOpacity(0.1),
                          tabBarIndicatorSize: TabBarIndicatorSize.tab,
                          indicatorRadius: 12,
                          insets: EdgeInsets.all(12),
                          padding: EdgeInsets.all(10)),
                      tabs: [
                        HomeTab(
                          text: "Notice\nBoard",
                          color: kCyan,
                        ),
                        HomeTab(
                          text: "Upcoming\nTasks",
                          color: kBlue,
                        ),
                        HomeTab(
                          text: "Classes\nToday",
                          color: kPurple,
                        ),
                      ]),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  padding: EdgeInsets.all(20),

//                      width: MediaQuery.of(context).size.height * 0.5,
                  height: MediaQuery.of(context).size.height * 0.55,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: TabBarView(
                    children: [noticeBoard(), upcomingTasks(), classesToday()],
                  ),
                ),
              ],
            ))
      ]),
    );
  }

  Widget noticeBoard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Notice Board",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            FutureBuilder(
              future: getRole(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && snapshot.data == "teacher") {
                  print(snapshot.data);
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => AddNotice(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        isScrollControlled: true,
                        backgroundColor: Color(0xff2A2D41),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        child: Icon(Icons.add),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: kCyan,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black54)
                            ]),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        FutureBuilder(
            future: getUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                String userBranch =
                    snapshot.data["branch"].toString().toLowerCase();
                String userRole = snapshot.data["role"];
                return StreamBuilder(
                    stream: DatabaseMethods().getNotices(userBranch),
                    builder: (context, snapshotN) {
                      if (snapshotN.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        if (snapshotN.hasData) {
                          var notices = snapshotN.data.docs;
                          return Flexible(
                              child: ListView.builder(
                                  itemCount: notices.length,
                                  itemBuilder: (context, i) {
                                    return NoticeTile(
                                        isFaculty: userRole == "teacher",
                                        notice: notices[i]);
                                  }));
                        } else {
                          return Text(
                            'No Data...',
                          );
                        }
                      }
                    });
              } else
                return Container();
            })
      ],
    );
  }

  Widget upcomingTasks() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Upcoming Tasks",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            FutureBuilder(
                future: getRole(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.data == "teacher") {
                    print(snapshot.data);
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => AddTask(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          isScrollControlled: true,
                          backgroundColor: Color(0xff2A2D41),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                            child: Icon(Icons.add),
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: kBlue,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 4,
                                      color: Colors.black54)
                                ])),
                      ),
                    );
                  } else {
                    return Container();
                  }
                })
          ],
        ),
        SizedBox(
          height: 5,
        ),
        FutureBuilder(
            future: getUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
//                                    String userBranch = snapshot.data["branch"]
//                                        .toString()
//                                        .toLowerCase();
//                                    String userRole = snapshot.data["role"];
                return StreamBuilder(
                    stream: DatabaseMethods().getTasks(Constants.myBranch),
//
                    builder: (context, snapshot) {
                      Future.delayed(Duration(milliseconds: 100));
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        if (snapshot.hasData) {
                          List tasks = snapshot.data.docs;
                          print(tasks);
                          return Flexible(
                            child: ListView.builder(
                                itemCount: tasks.length,
                                itemBuilder: (context, i) {
                                  return TaskTile(
                                    task: tasks[i],
                                    isFaculty: Constants.myRole == "teacher",
                                  );
                                }),
                          );
                        } else {
                          return Text(
                            'No Data...',
                          );
                        }
                      }
                    });
              } else
                return Container();
            })
      ],
    );
  }

  Widget classesToday() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Classes Today",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                child: Icon(Icons.edit),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: kPurple,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(1, 1),
                          blurRadius: 4,
                          color: Colors.black54)
                    ]),
              ),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        FutureBuilder(
            future: getUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                String userBranch =
                    snapshot.data["branch"].toString().toLowerCase();
                String userRole = snapshot.data["role"];
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("timetable")
                        .doc(getDay())
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text(
                          'No Data...',
                        );
                      } else {
                        var subArray = snapshot.data[userBranch];

                        return Flexible(
                          child: ListView(children: [
                            ScheduleTile(
                              time: "09:00 - 10:00",
                              sub: subArray[0],
                              subFull: subjects[subArray[0]],
                            ),
                            ScheduleTile(
                              time: "10:00 - 11:00",
                              sub: subArray[1],
                              subFull: subjects[subArray[1]],
                            ),
                            ScheduleTile(
                              time: "11:00 - 12:00",
                              sub: subArray[2],
                              subFull: subjects[subArray[2]],
                            ),
                            ScheduleTile(
                              time: "12:00 - 13:00",
                              sub: "BREAK",
                              color: kPurple,
                            ),
                            ScheduleTile(
                              time: "13:00 - 14:00",
                              sub: subArray[3],
                              subFull: subjects[subArray[3]],
                            ),
                            ScheduleTile(
                              time: "14:00 - 15:00",
                              sub: subArray[4],
                              subFull: subjects[subArray[4]],
                            ),
                            ScheduleTile(
                              time: "15:00 - 16:00",
                              sub: subArray[5],
                              subFull: subjects[subArray[5]],
                            ),
                          ]),
                        );
                      }
                    });
              } else
                return Text("no user data found");
            })
      ],
    );
  }
}

class HomeTab extends StatelessWidget {
  final String text;
  final Color color;
  const HomeTab({this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.22,
      height: MediaQuery.of(context).size.width * 0.18,
      padding: EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Tab(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
