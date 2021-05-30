import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eduverse/Utils/constants.dart';

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
                  '${DateFormat("h:mm a").format(notice["created"].toDate())}, ${DateFormat("dd-MM-yy").format(notice["created"].toDate())}'),
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

class ScheduleTile extends StatelessWidget {
  final String time;
  final String sub;
  final String subFull;
  final Color color;
  const ScheduleTile({this.time, this.sub, this.subFull, this.color});

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
