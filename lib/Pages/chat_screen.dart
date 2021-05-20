import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduverse/Services/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/rendering.dart';
import 'package:eduverse/Pages/share.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:intl/intl.dart';

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
  FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage=FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<UploadTask> uploadTasks=List();
  List<File> selectedFiles=List();
  List messages;
  String extension;
  String name ;
  int size ;
  var userRole;
  var user;
  var userName;
  var userNameChat;
  final TextEditingController _messageController = TextEditingController();
  writeImageUrlToFirestore(imageUrl,typeSelected,size,name,extension){
    Map<String, dynamic>messageData = {
      "text": imageUrl,
      "sent_by": Constants.myName,
      "time": DateTime.now(),
      "file_type": typeSelected,
      "name":name,
      "size":size,
      "extension":extension,
    };
    Map<String, dynamic>fileData = {
      "text": imageUrl,
      "name": name,
      "size": size,
      "extension": extension,
    };
    DatabaseMethods().addMessage("groups", widget.groupId, messageData);

    DatabaseMethods().addImage("groups", widget.groupId, fileData,typeSelected);


  }
  saveImageUrlToFirebase(UploadTask task,String typeSelected,size,name,extension){
task.snapshotEvents.listen((snapShot) {
  if(snapShot.state==TaskState.success){
    snapShot.ref.getDownloadURL().then((imageUrl) => writeImageUrlToFirestore(imageUrl,typeSelected,size,name,extension));

  }
});
  }
  uploadFileToStorage(File file,String typeSelected) {

    UploadTask task=_firebaseStorage.ref().child("$typeSelected/${DateTime.now().toString()}").putFile(file);
    return task;
  }

 Future selectFileToUpload(String typeSelected,FileType typeOfFile) async{
   try{
     FilePickerResult result= await FilePicker.platform.pickFiles(allowMultiple: true,type: typeOfFile);
     if(result!=null){
       selectedFiles.clear();
           result.files.forEach((selectedFile) {
             File file =File(selectedFile.path);
             name =selectedFile.name;
              size =selectedFile.size;
              extension =selectedFile.extension;
             print(size);
             print(name);
             selectedFiles.add(file);
           });
           selectedFiles.forEach((file) {
             final UploadTask task =uploadFileToStorage(file,typeSelected);
             saveImageUrlToFirebase(task,typeSelected,size,name,extension);
             setState(() {
               uploadTasks.add(task);
             });
           });
     }else{
       print("user has cancelled");
     }
   }catch(e){
     print(e);
   }
 }
  addMessage() {
    Map<String, dynamic> messageData = {
      "text": _messageController.text,
      "sent_by": Constants.myName,
      "time": DateTime.now(),
      "file_type":"text"
    };

    widget.isGroup
        ? DatabaseMethods().addMessage("groups", widget.groupId, messageData)
        : DatabaseMethods().addMessage("chats", widget.groupId, messageData);

    _messageController.clear();
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
                // image: DecorationImage(
                //     image: AssetImage('assets/images/sarah.jpg'),
                //     fit: BoxFit.fill),
              ),
            ),
            Text(widget.name, style: TextStyle(fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Tabs(groupId: widget.groupId,)),
                );
              },
              icon: Icon(Icons.perm_media))
        ],
      ),
      body: Column(
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
                        .orderBy("time")
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('chats')
                        .doc(widget.groupId)
                        .collection('messages')
                        .orderBy("time")
                        .snapshots(),
                builder: (context, userSnapshot) {
                  return userSnapshot.hasData
                      ? ListView.builder(
                          itemCount: userSnapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            if(userSnapshot.data.docs[index]["file_type"]=="images"){
                              return userSnapshot.data.docs[index]["sent_by"] ==
                                  Constants.myName
                                  ? Container(
                                  color: Colors.transparent,
                                  child: ImageBubble(
                                    isUser: true,
                                    imageUrl: userSnapshot.data.docs[index]
                                    ["text"],
                                    time: userSnapshot.data.docs[index]
                                    ["time"],
                                    userName: userSnapshot.data.docs[index]
                                    ["sent_by"],
                                  ))
                                  : Container(
                                  color: Colors.transparent,
                                  child: ImageBubble(
                                    isUser: false,
                                    imageUrl: userSnapshot.data.docs[index]
                                    ["text"],
                                    time: userSnapshot.data.docs[index]
                                    ["time"],
                                    userName: userSnapshot.data.docs[index]
                                    ["sent_by"],
                                  ));
                            }
                            else if(userSnapshot.data.docs[index]["file_type"]=="text"){
                              return userSnapshot.data.docs[index]["sent_by"] ==
                                  Constants.myName
                                  ? Container(
                                  color: Colors.transparent,
                                  child: ChatBubble(
                                    isUser: true,
                                    messageText: userSnapshot.data.docs[index]
                                    ["text"],
                                    time: userSnapshot.data.docs[index]
                                    ["time"],
                                    userName: userSnapshot.data.docs[index]
                                    ["sent_by"],
                                  ))
                                  : Container(
                                  color: Colors.transparent,
                                  child: ChatBubble(
                                    isUser: false,
                                    messageText: userSnapshot.data.docs[index]
                                    ["text"],
                                    time: userSnapshot.data.docs[index]
                                    ["time"],
                                    userName: userSnapshot.data.docs[index]
                                    ["sent_by"],
                                  ));
                            }
                            else{
                              return userSnapshot.data.docs[index]["sent_by"] ==
                                  Constants.myName
                                  ? Container(
                                  color: Colors.transparent,
                                  child: FileBubble(
                                    isUser: true,
                                    fileName: userSnapshot.data.docs[index]
                                    ["name"],
                                    time: userSnapshot.data.docs[index]
                                    ["time"],
                                    userName: userSnapshot.data.docs[index]
                                    ["sent_by"],
                                    fileExtension: userSnapshot.data.docs[index]
                                    ["extension"],
                                    fileSize: userSnapshot.data.docs[index]
                                    ["size"],
                                  ))
                                  : Container(
                                  color: Colors.transparent,
                                  child: FileBubble(
                                    isUser: false,
                                    fileName: userSnapshot.data.docs[index]
                                    ["name"],
                                    time: userSnapshot.data.docs[index]
                                    ["time"],
                                    userName: userSnapshot.data.docs[index]
                                    ["sent_by"],
                                    fileExtension: userSnapshot.data.docs[index]
                                    ["extension"],
                                    fileSize: userSnapshot.data.docs[index]
                                    ["size"],
                                  ));

                            }
                          })
                      : Center(child: CircularProgressIndicator());
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
                    addMessage();
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (builder) => bottomSheet(context));
                },
                icon: Transform.rotate(
                  angle: 3.8,
                  child: Icon(
                    Icons.attach_file,
                    size: 25.0,
                    color: Colors.grey,
                  ),
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
                    onTap: (){
                      selectFileToUpload("materials",FileType.any);
                    },
                    child: iconCreation(
                        Icons.insert_drive_file, kCyan, 'Material', context),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  GestureDetector(
                    onTap: (){
                      selectFileToUpload("assignments",FileType.any);
                    },
                      child: iconCreation(Icons.assignment, kBlue, 'Assignment', context)),
                  SizedBox(
                    width: 40,
                  ),
                  GestureDetector(
                      onTap: (){
                        selectFileToUpload("images",FileType.image);
                      },
                      child: iconCreation(Icons.image, kPurple, 'Image', context))
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
                  Text(
                    isUser ? "" : userName,
                    style: TextStyle(
                      color: kCyan,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
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
            //borderWidth: 20,
            color:
            isUser ? kBlue.withOpacity(0.8) : Colors.white.withOpacity(0.1),
            radius: Radius.circular(8),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isUser ? "" : userName,
                    style: TextStyle(
                      color: kCyan,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.network(imageUrl)
               ,
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
  const FileBubble({this.isUser, this.fileName, this.time, this.userName,this.fileExtension,this.fileSize});
  final String fileExtension;
  final bool isUser;
  final String userName;
  final String fileName;
  final int fileSize;
  final Timestamp time;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 250,
          child: Bubble(
            //borderWidth: 20,
            color:
            isUser ? kBlue.withOpacity(0.8) : Colors.white.withOpacity(0.1),
            radius: Radius.circular(8),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isUser ? "" : userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
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
                    (fileSize/1000).toString()+'KB',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Align(
                      alignment: Alignment.bottomRight,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
