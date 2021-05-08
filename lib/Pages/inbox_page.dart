import 'package:flutter/material.dart';
import 'package:eduverse/Components/chat_name_card.dart';

class InboxWidget extends StatelessWidget {
  const InboxWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inbox',
          style: TextStyle(fontSize: 25),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
        titleSpacing: 0,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.transparent,
            child: ChatNameCard(
              name: "Faculty 1",
            ),
          );
        },
      ),
    );
  }
}
