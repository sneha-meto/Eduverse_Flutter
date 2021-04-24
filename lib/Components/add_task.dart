import 'package:flutter/material.dart';
import 'package:eduverse/constants.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime _dueDate = DateTime.now();

  String _dateText = '';

  Future<Null> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _dueDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2050));
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dateText = '${picked.day}-${picked.month}-${picked.year}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dateText = '${_dueDate.day}-${_dueDate.month}-${_dueDate.year}';
  }

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
                Text("Add Task",
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
                      maxLength: 50,
                      maxLines: 2,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration.collapsed(
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "Enter task.."),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Due :",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        TextButton(
                          onPressed: () => _selectDueDate(context),
                          child: Text('$_dateText',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ]),
                  padding: EdgeInsets.all(15.0),
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
                  ], color: kBlue, borderRadius: BorderRadius.circular(10)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
