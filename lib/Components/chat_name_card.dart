import 'package:flutter/material.dart';
import 'package:eduverse/Pages/chat_screen.dart';
import 'package:eduverse/Utils/constants.dart';
import 'dart:math';

class ChatNameCard extends StatelessWidget {
  ChatNameCard(
      {@required this.name, @required this.groupId, @required this.isGroup});
  final String name;
  final String groupId;
  final bool isGroup;
  final Random random = Random();
  getRandomColour() {
    var themeColours = [kBlue, kCyan, kPurple];
    return themeColours[random.nextInt(3)];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    groupId: groupId,
                    name: name,
                    isGroup: isGroup,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          shape: BoxShape.rectangle,
        ),
        child: Row(
          children: [
            Container(
              // padding: EdgeInsets.all(25),
              child: Center(
                  child: Text(
                name[0].toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                          color: Colors.black45,
                          offset: Offset(1, 1),
                          blurRadius: 5)
                    ]),
              )),
              width: 50,
              height: 50,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: getRandomColour(),
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                // image: DecorationImage(
                //     image: AssetImage('assets/images/sarah.jpg'),
                //     fit: BoxFit.fill),
              ),
            ),
            Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
