import 'package:flutter/material.dart';
import 'package:eduverse/Components/chat_name_card.dart';

class GroupsWidget extends StatelessWidget {
  const GroupsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Groups',
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
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.transparent,
            child: ChatNameCard(name: "IT Official"),
          );
        },
      ),
    );
  }
}
