import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:intl/intl.dart';
import 'package:eduverse/Utils/constants.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({this.isUser, this.messageText, this.time, this.userName});
  final bool isUser;
  final String userName;
  final String messageText;
  final Timestamp time;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 220,
          child: Bubble(
            nip: isUser ? BubbleNip.rightBottom : BubbleNip.leftBottom,
            borderWidth: 20,
            color:
                isUser ? kBlue.withOpacity(0.8) : Colors.white.withOpacity(0.1),
            radius: Radius.circular(15),
            nipRadius: 0,
            nipHeight: 15,
            nipWidth: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: !isUser,
                    child: Text(
                      userName,
                      style: TextStyle(
                        color: kCyan,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(messageText,
                      style: TextStyle(fontSize: 15.0, color: Colors.white)),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat.jm().format(time.toDate()),
                          style: TextStyle(fontSize: 12.0, color: Colors.white),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageBubble extends StatelessWidget {
  const ImageBubble({this.isUser, this.imageUrl, this.time, this.userName});
  final bool isUser;
  final String userName;
  final String imageUrl;
  final Timestamp time;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 220,
          child: Bubble(
            nip: isUser ? BubbleNip.rightBottom : BubbleNip.leftBottom,
            borderWidth: 20,
            color:
                isUser ? kBlue.withOpacity(0.8) : Colors.white.withOpacity(0.1),
            radius: Radius.circular(15),
            nipRadius: 0,
            nipHeight: 15,
            nipWidth: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                      visible: !isUser,
                      child: Text(
                        userName,
                        style: TextStyle(
                          color: kCyan,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Image.network(imageUrl),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat.jm().format(time.toDate()),
                          style: TextStyle(fontSize: 12.0, color: Colors.white),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FileBubble extends StatelessWidget {
  const FileBubble(
      {this.isUser,
      this.fileName,
      this.time,
      this.userName,
      this.fileExtension,
      this.fileSize,
      this.category});
  final String fileExtension;
  final bool isUser;
  final String userName;
  final String fileName;
  final int fileSize;
  final Timestamp time;
  final String category;

  String getSize(int size) {
    double mb = size / (1000 * 1000);
    double kb = size / 1000;
    if (mb < 1)
      return "${kb.toStringAsFixed(2)} KB";
    else
      return "${mb.toStringAsFixed(2)} MB";
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 250,
          child: Bubble(
            nip: isUser ? BubbleNip.rightBottom : BubbleNip.leftBottom,
            borderWidth: 20,
            color:
                isUser ? kBlue.withOpacity(0.8) : Colors.white.withOpacity(0.1),
            radius: Radius.circular(15),
            nipRadius: 0,
            nipHeight: 15,
            nipWidth: 1,
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: !isUser,
                      child: Text(
                        userName,
                        style: TextStyle(
                          color: kCyan,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "• " +
                          category
                              .substring(0, category.length - 1)
                              .toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(offset: Offset(1, 1), blurRadius: 2)
                          ]),
                    ),
                    Text(
                      fileName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      getSize(fileSize),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
//                      alignment: Alignment.bottomRight,
                  child: Column(
                    children: [
                      Text(
                        fileExtension.toUpperCase(),
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      Text(
                        DateFormat.jm().format(time.toDate()),
                        style: TextStyle(fontSize: 12.0, color: Colors.white),
                      ),
                    ],
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}
