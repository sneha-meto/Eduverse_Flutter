import 'package:eduverse/Pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:eduverse/data.dart' as data;
import 'package:eduverse/constants.dart';
import 'package:eduverse/Components/add_notice.dart';
import 'package:eduverse/Components/add_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eduverse/Pages/login.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
          Text(
            "Hi User!",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          Expanded(
            child: IconButton(
                alignment: Alignment.centerRight,
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onPressed: () {
                  final FirebaseAuth _auth = FirebaseAuth.instance;

                  Future<void> _signOut() async {
                    await _auth.signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Login(),
                        ));
                  }
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
                            GestureDetector(
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
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Flexible(
                          child: ListView.builder(
                              itemCount: data.notices.length,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 0),
                                  child: Container(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(data.notices[i].facultyName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(data.notices[i].date)
                                            ],
                                          ),
                                          Text(data.notices[i].noticeText)
                                        ]),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                );
                              }),
                        )
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
                            GestureDetector(
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
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Flexible(
                          child: ListView.builder(
                              itemCount: data.tasks.length,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 0),
                                  child: Container(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(data.tasks[i].facultyName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(data.tasks[i].due)
                                            ],
                                          ),
                                          Text(data.tasks[i].task)
                                        ]),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                );
                              }),
                        )
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
                        Flexible(
                          child: ListView(children: [
                            ScheduleCard(
                              time: "09:00 - 10:00",
                              sub: "IP",
                              subFull: "Internet Programming",
                            ),
                            ScheduleCard(
                              time: "10:00 - 11:00",
                              sub: "DAA",
                              subFull: "Discrete Analysis of alg",
                            ),
                            ScheduleCard(
                              time: "11:00 - 12:00",
                              sub: "OS",
                              subFull: "Operating sys",
                            ),
                            ScheduleCard(
                              time: "12:00 - 13:00",
                              sub: "BREAK",
                              color: kPurple,
                            ),
                            ScheduleCard(
                              time: "13:00 - 14:00",
                              sub: "NSM",
                              subFull:
                                  "Numerical and statistical methods and whatever",
                            ),
                            ScheduleCard(
                              time: "14:00 - 15:00",
                              sub: "IP",
                              subFull: "Internet Programming",
                            ),
                            ScheduleCard(
                              time: "15:00 - 16:00",
                              sub: "IP",
                              subFull: "Internet Programming",
                            ),
                          ]),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ))
    ]);
  }
}

class HomeTab extends StatelessWidget {
  final String text;
  final Color color;
  const HomeTab({this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      padding: EdgeInsets.all(12),
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
