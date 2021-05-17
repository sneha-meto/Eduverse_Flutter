import 'package:eduverse/Pages/profile.dart';
import 'package:eduverse/Services/user.dart';
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
    String role;
    String name;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser.uid)
        .get()
        .then((value) {
      role = value.data()["role"] + "s";
      UserHelper.saveRole(value.data()["role"]);
    });

    var value = await FirebaseFirestore.instance
        .collection(role)
        .doc(_auth.currentUser.uid)
        .get();
//    name = value.data()["first_name"];

    UserHelper.saveName(
        value.data()["first_name"] + " " + value.data()["last_name"]);
    return value;
  }

  Future getRole() async {
    var value = await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser.uid)
        .get();
    var role = value.data()["role"];
    return role;
  }

  @override
  Widget build(BuildContext context) {
    getDay();

    return Stack(children: [
      SingleChildScrollView(
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
                      children: [
                        Column(
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
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data == "teacher") {
                                      print(snapshot.data);
                                      return GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => AddNotice(),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
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
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("notices")
                                    .where("branch",
                                        isEqualTo: Constants.myBranch)
                                    .snapshots(),
                                builder: (context, snapshotN) {
                                  if (snapshotN.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    if (snapshotN.hasData) {
                                      var notices = snapshotN.data.docs;
                                      return Flexible(
                                          child: ListView.builder(
                                              itemCount: notices.length,
                                              itemBuilder: (context, i) {
                                                return NoticeTile(
                                                    isFaculty:
                                                        Constants.myRole ==
                                                            "teacher",
                                                    notice: notices[i]);
                                              }));
                                    } else {
                                      return Text(
                                        'No Data...',
                                      );
                                    }
                                  }
                                })
                          ],
                        ),
                        Column(
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
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data == "teacher") {
                                        print(snapshot.data);
                                        return GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) => AddTask(),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Color(0xff2A2D41),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                                child: Icon(Icons.add),
                                                padding: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    color: kBlue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("tasks")
                                    .where("branch",
                                        isEqualTo: Constants.myBranch)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
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
                                                isFaculty: Constants.myRole ==
                                                    "teacher",
                                              );
                                            }),
                                      );
                                    } else {
                                      return Text(
                                        'No Data...',
                                      );
                                    }
                                  }
                                })
                          ],
                        ),
                        Column(
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
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    String userBranch = snapshot.data["branch"]
                                        .toString()
                                        .toLowerCase();
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
                                            var subArray =
                                                snapshot.data[userBranch];

                                            return Flexible(
                                              child: ListView(children: [
                                                ScheduleCard(
                                                  time: "09:00 - 10:00",
                                                  sub: subArray[0],
                                                  subFull:
                                                      subjects[subArray[0]],
                                                ),
                                                ScheduleCard(
                                                  time: "10:00 - 11:00",
                                                  sub: subArray[1],
                                                  subFull:
                                                      subjects[subArray[1]],
                                                ),
                                                ScheduleCard(
                                                  time: "11:00 - 12:00",
                                                  sub: subArray[2],
                                                  subFull:
                                                      subjects[subArray[2]],
                                                ),
                                                ScheduleCard(
                                                  time: "12:00 - 13:00",
                                                  sub: "BREAK",
                                                  color: kPurple,
                                                ),
                                                ScheduleCard(
                                                  time: "13:00 - 14:00",
                                                  sub: subArray[3],
                                                  subFull:
                                                      subjects[subArray[3]],
                                                ),
                                                ScheduleCard(
                                                  time: "14:00 - 15:00",
                                                  sub: subArray[4],
                                                  subFull:
                                                      subjects[subArray[4]],
                                                ),
                                                ScheduleCard(
                                                  time: "15:00 - 16:00",
                                                  sub: subArray[5],
                                                  subFull:
                                                      subjects[subArray[5]],
                                                ),
                                              ]),
                                            );
                                          }
                                        });
                                  } else
                                    return Text("no user data found");
                                })
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ]),
      ),
    ]);
  }
}

class TaskTile extends StatelessWidget {
  TaskTile({this.task, this.isFaculty});
  final DocumentSnapshot task;
  final bool isFaculty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(task["faculty"],
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(DateFormat("dd-MM-yy").format(task["due"].toDate()))
            ],
          ),
          Text(task["task"]),
          Visibility(
            visible: isFaculty,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onLongPress: () {
                    FirebaseFirestore.instance
                        .collection("tasks")
                        .doc(task.reference.id)
                        .delete()
                        .then((_) {
                      print("delete success!");
                    });
                  },
                  child: Icon(
                    Icons.delete,
                    color: kScaffold,
                    size: 20,
                  ),
                ),
              ],
            ),
          )
        ]),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class NoticeTile extends StatelessWidget {
  NoticeTile({this.notice, this.isFaculty});
  final DocumentSnapshot notice;
  final bool isFaculty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(notice["faculty"],
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                  '${DateFormat("h:mma").format(notice["created"].toDate())}, ${DateFormat("dd-MM-yy").format(notice["created"].toDate())}'),
            ],
          ),
          Text(notice["notice"]),
          Visibility(
            visible: isFaculty,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onLongPress: () {
                    FirebaseFirestore.instance
                        .collection("notices")
                        .doc(notice.reference.id)
                        .delete()
                        .then((_) {
                      print("delete success!");
                    });
                  },
                  child: Icon(
                    Icons.delete,
                    color: kScaffold,
                    size: 20,
                  ),
                ),
              ],
            ),
          )
        ]),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10)),
      ),
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

class ScheduleCard extends StatelessWidget {
  final String time;
  final String sub;
  final String subFull;
  final Color color;
  const ScheduleCard({this.time, this.sub, this.subFull, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
      child: Container(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 20.0,
              ),
              child: Text(time,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sub ?? "",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  subFull ?? "",
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ))
          ],
        ),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: color ?? Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
