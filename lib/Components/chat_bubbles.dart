import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';

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

class FileBubble extends StatefulWidget {
  const FileBubble(
      {this.isUser,
      this.fileLink,
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
  final String fileLink;

  @override
  _FileBubbleState createState() => _FileBubbleState();
}

class _FileBubbleState extends State<FileBubble> {
  bool downloading = false;
  String progressString = "";
  double downloadProgress = 0;
  final snackBar = SnackBar(
    content: Text(
      "Download Completed",
      textAlign: TextAlign.center,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    margin: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
    behavior: SnackBarBehavior.floating,
    backgroundColor: kPurple,
  );

  String getSize(int size) {
    double mb = size / (1000 * 1000);
    double kb = size / 1000;
    if (mb < 1)
      return "${kb.toStringAsFixed(2)} KB";
    else
      return "${mb.toStringAsFixed(2)} MB";
  }

  Future<void> downloadFile(fileUrl, fileName) async {
    Dio dio = Dio();
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
//        var dir = await getExternalStorageDirectory();

        await dio.download(fileUrl, "/storage/emulated/0/Download/" + fileName,
            onReceiveProgress: (rec, total) {
          print("Rec: $rec , Total: $total");

          setState(() {
            downloading = true;
            progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
            downloadProgress = (rec / total);
          });
        });
      } catch (e) {
        print(e);
      }

      setState(() {
        downloading = false;
        progressString = "Completed";
      });
      print("Download completed");
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      print("Permission Denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isUser) {
          downloadFile(widget.fileLink, widget.fileName);
        }
      },
      child: Stack(children: [
        Align(
            alignment:
                widget.isUser ? Alignment.bottomRight : Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 250,
                child: Bubble(
                  nip: widget.isUser
                      ? BubbleNip.rightBottom
                      : BubbleNip.leftBottom,
                  borderWidth: 20,
                  color: widget.isUser
                      ? kBlue.withOpacity(0.8)
                      : Colors.white.withOpacity(0.1),
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
                            visible: !widget.isUser,
                            child: Text(
                              widget.userName,
                              style: TextStyle(
                                color: kCyan,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "• " +
                                widget.category
                                    .substring(0, widget.category.length - 1)
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
                            widget.fileName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            getSize(widget.fileSize) +
                                " • " +
                                widget.fileExtension.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              DateFormat.jm().format(widget.time.toDate()),
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            )),
        !widget.isUser
            ? Positioned(
                bottom: 18,
                left: 25,
                width: 150,
                child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kCyan),
                    backgroundColor: Colors.white70,
                    value: downloadProgress))
            : Container()
      ]),
    );
  }
}
