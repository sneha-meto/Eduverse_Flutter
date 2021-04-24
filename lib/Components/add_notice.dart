import 'package:flutter/material.dart';
import 'package:eduverse/constants.dart';

class AddNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height * 0.4,
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
                      onChanged: (val) {},
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
                Container(
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
