import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduverse/Services/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:eduverse/Pages/media.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:eduverse/Components/chat_bubbles.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {@required this.groupId, @required this.name, @required this.isGroup});
  final String groupId;
  final String name;
  final bool isGroup;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<UploadTask> uploadTasks = List();
  List<File> selectedFiles = List();
  List messages;
  String extension;
  String name;
  int size;
  var userRole;
  var user;
  var userName;
  var userNameChat;
  String typeSelected;

  writeFileUrlToFirestore(imageUrl, typeSelected, size, name, extension) {
    Map<String, dynamic> messageData = {
      "text": imageUrl,
      "sent_by": Constants.myName,
      "time": DateTime.now(),
      "file_type": typeSelected,
      "name": name,
      "size": size,
      "extension": extension,
    };
    Map<String, dynamic> fileData = {
      "text": imageUrl,
      "name": name,
      "size": size,
      "extension": extension,
      "time": DateTime.now(),
      "sent_by": Constants.myName,
    };

    if (widget.isGroup) {
      DatabaseMethods().addMessage("groups", widget.groupId, messageData);
      DatabaseMethods()
          .addFile("groups", widget.groupId, fileData, typeSelected);
    } else {
      DatabaseMethods().addMessage("chats", widget.groupId, messageData);
      DatabaseMethods()
          .addFile("chats", widget.groupId, fileData, typeSelected);
    }
  }

  saveFileUrlToFirestore(
      UploadTask task, String typeSelected, size, name, extension) {
    task.snapshotEvents.listen((snapShot) {
      if (snapShot.state == TaskState.success) {
        snapShot.ref.getDownloadURL().then((imageUrl) =>
            writeFileUrlToFirestore(
                imageUrl, typeSelected, size, name, extension));
      }
    });
  }

  uploadFileToStorage(File file, String typeSelected) {
    UploadTask task = _firebaseStorage
        .ref()
        .child("$typeSelected/${DateTime.now().toString()}")
        .putFile(file);
    return task;
  }

  Future selectFileToUpload(String typeSelected, FileType typeOfFile) async {
    try {
      FilePickerResult result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: typeOfFile);
      if (result != null) {
        result.files.forEach((selectedFile) {
          File file = File(selectedFile.path);
          name = selectedFile.name;
          size = selectedFile.size;
          extension = selectedFile.extension;
          print(size);
          print(name);
          selectedFiles.add(file);
        });

        this.typeSelected = typeSelected;
      } else {
        print("user has cancelled");
      }
    } catch (e) {
      print(e);
    }
  }

  send(bool isFile) {
    if (!isFile) {
      Map<String, dynamic> messageData = {
        "text": _messageController.text,
        "sent_by": Constants.myName,
        "time": DateTime.now(),
        "file_type": "text"
      };
      if (_messageController.text.isNotEmpty) {
        widget.isGroup
            ? DatabaseMethods()
                .addMessage("groups", widget.groupId, messageData)
            : DatabaseMethods()
                .addMessage("chats", widget.groupId, messageData);

        _messageController.clear();
      }
    } else {
      selectedFiles.forEach((file) {
        final UploadTask task = uploadFileToStorage(file, typeSelected);
        saveFileUrlToFirestore(task, typeSelected, size, name, extension);
        setState(() {
          uploadTasks.add(task);
        });
      });
      selectedFiles.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.1),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Row(
          children: [
            Container(
              // padding: EdgeInsets.all(25),
              width: 38,
              height: 38,
              margin: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: kCyan,
                borderRadius: BorderRadius.circular(11),
                shape: BoxShape.rectangle,
              ),
            ),
            Flexible(child: Text(widget.name, style: TextStyle(fontSize: 20))),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatMedia(
                            groupId: widget.groupId,
                            name: widget.name,
                            isGroup: widget.isGroup,
                          )),
                );
              },
              icon: Icon(Icons.perm_media)),
        ],
      ),
      body:
//      Stack(children: [
          Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: StreamBuilder(
                stream: widget.isGroup
                    ? FirebaseFirestore.instance
                        .collection('groups')
                        .doc(widget.groupId)
                        .collection('messages')
                        .orderBy("time", descending: true)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('chats')
                        .doc(widget.groupId)
                        .collection('messages')
                        .orderBy("time", descending: true)
                        .snapshots(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else
                    return userSnapshot.hasData
                        ? ListView.builder(
                            reverse: true,
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: userSnapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              if (userSnapshot.data.docs[index]["file_type"] ==
                                  "images") {
                                return Container(
                                    color: Colors.transparent,
                                    child: ImageBubble(
                                      isUser: userSnapshot.data.docs[index]
                                              ["sent_by"] ==
                                          Constants.myName,
                                      imageUrl: userSnapshot.data.docs[index]
                                          ["text"],
                                      time: userSnapshot.data.docs[index]
                                          ["time"],
                                      userName: userSnapshot.data.docs[index]
                                          ["sent_by"],
                                      fileName: userSnapshot.data.docs[index]
                                          ["name"],
                                    ));
                              } else if (userSnapshot.data.docs[index]
                                      ["file_type"] ==
                                  "text") {
                                return Container(
                                    color: Colors.transparent,
                                    child: ChatBubble(
                                      isUser: userSnapshot.data.docs[index]
                                              ["sent_by"] ==
                                          Constants.myName,
                                      messageText: userSnapshot.data.docs[index]
                                          ["text"],
                                      time: userSnapshot.data.docs[index]
                                          ["time"],
                                      userName: userSnapshot.data.docs[index]
                                          ["sent_by"],
                                    ));
                              } else {
                                return Container(
                                    color: Colors.transparent,
                                    child: FileBubble(
                                        isUser: userSnapshot.data.docs[index]
                                                ["sent_by"] ==
                                            Constants.myName,
                                        fileLink: userSnapshot.data.docs[index]
                                            ["text"],
                                        fileName: userSnapshot.data.docs[index]
                                            ["name"],
                                        time: userSnapshot.data.docs[index]
                                            ["time"],
                                        userName: userSnapshot.data.docs[index]
                                            ["sent_by"],
                                        fileExtension: userSnapshot
                                            .data.docs[index]["extension"],
                                        fileSize: userSnapshot.data.docs[index]
                                            ["size"],
                                        category: userSnapshot.data.docs[index]
                                            ["file_type"]));
                              }
                            })
                        : Center(child: Text("No messages found"));
                },
              ),
            ),
          ),
          Container(
//            color: Colors.white.withOpacity(0.1),
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: roundedContainer(),
                ),
                SizedBox(
                  width: 5.0,
                ),
                GestureDetector(
                  onTap: () {
                    send(selectedFiles.isNotEmpty);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0), //or 15.0
                    child: Container(
                      height: 45.0,
                      width: 45.0,
                      color: kCyan,
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                  // child: CircleAvatar(
                  // child: Icon(Icons.send),
                  // ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget roundedContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          color: Colors.white.withOpacity(0.2),
          child: Row(
            children: <Widget>[
              SizedBox(width: 8.0),
              Visibility(
                visible: selectedFiles.isNotEmpty,
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Icon(
                      Icons.file_copy,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TextField(
                    readOnly: selectedFiles.isEmpty ? false : true,
                    style: TextStyle(color: Colors.white),
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: selectedFiles.isEmpty
                          ? 'Type a message'
                          : "Files Selected",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  selectedFiles.isNotEmpty
                      ? setState(() {
                          selectedFiles.clear();
                        })
                      : showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (builder) => bottomSheet(context));
                },
                icon: selectedFiles.isEmpty
                    ? Transform.rotate(
                        angle: 3.8,
                        child: Icon(
                          Icons.attach_file,
                          size: 25.0,
                          color: Colors.grey,
                        ),
                      )
                    : Icon(
                        Icons.close,
                        size: 25.0,
                        color: Colors.grey,
                      ),
              ),
              SizedBox(width: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet(context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: 220,
      child: Column(
        children: [
          Card(
            color: Color(0xff2A2D41),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.all(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      selectFileToUpload("materials", FileType.any);
                    },
                    child: iconCreation(
                        Icons.insert_drive_file, kCyan, 'Material', context),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  GestureDetector(
                      onTap: () {
                        selectFileToUpload("assignments", FileType.any);
                      },
                      child: iconCreation(
                          Icons.assignment, kBlue, 'Assignment', context)),
                  SizedBox(
                    width: 40,
                  ),
                  GestureDetector(
                      onTap: () {
                        selectFileToUpload("images", FileType.image);
                      },
                      child:
                          iconCreation(Icons.image, kPurple, 'Image', context))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  Widget iconCreation(
      IconData icon, Color color, String text, BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0), //or 15.0
          child: Container(
            height: 45.0,
            width: 45.0,
            color: color,
            child: Icon(icon, color: Colors.white),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}
