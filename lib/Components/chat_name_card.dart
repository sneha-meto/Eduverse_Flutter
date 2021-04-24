import 'package:flutter/material.dart';
import 'package:eduverse/Pages/chat_screen.dart';

class ChatNameCard extends StatelessWidget {
  const ChatNameCard({@required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
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
              width: 50,
              height: 50,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                // image: DecorationImage(
                //     image: AssetImage('assets/images/sarah.jpg'),
                //     fit: BoxFit.fill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                name,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
