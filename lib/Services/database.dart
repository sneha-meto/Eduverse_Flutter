import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
//  Future<void> addUserInfo(userData) async {
//    FirebaseFirestore.instance.collection("users").add(userData).catchError((e) {
//      print(e.toString());
//    });
//  }

  getUserRole(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String id, String role) async {
    return await FirebaseFirestore.instance
        .collection(role + 's')
        .doc(id)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchKey) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('name', isGreaterThanOrEqualTo: searchKey)
        .where('name', isLessThan: searchKey + 'z')
        .get();
  }

  void createChat(newChat, chatId) {
    FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .set(newChat)
        .catchError((e) {
      print(e);
    });
  }

  void addMessage(collection, docId, messageData) {
    CollectionReference message = FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .collection('messages');
    message.add(messageData);
  }

  Future addImage(collection, docId, messageData) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(docId)
        .update({
      "images": FieldValue.arrayUnion([messageData])
    }).then((messageData) => print("subjects added"));
  }
//
//  getChats(String chatRoomId) async{
//    return FirebaseFirestore.instance
//        .collection("chatRoom")
//        .doc(chatRoomId)
//        .collection("chats")
//        .orderBy('time')
//        .snapshots();
//  }
//
//
//  Future<void> addMessage(String chatRoomId, chatMessageData){
//
//    FirebaseFirestore.instance.collection("chatRoom")
//        .doc(chatRoomId)
//        .collection("chats")
//        .add(chatMessageData).catchError((e){
//      print(e.toString());
//    });
//  }
//
//  getUserChats(String itIsMyName) async {
//    return await FirebaseFirestore.instance
//        .collection("chatRoom")
//        .where('users', arrayContains: itIsMyName)
//        .snapshots();
//  }

}
