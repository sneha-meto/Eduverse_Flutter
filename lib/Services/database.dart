import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future getUserRole(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future getUserInfo(String id, String role) async {
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

  Future addFile(collection, docId, messageData, String typeSelected) async {
    await FirebaseFirestore.instance.collection(collection).doc(docId).update({
      typeSelected: FieldValue.arrayUnion([messageData])
    }).then((messageData) => print("file added"));
  }

  getNotices(branch) {
    return FirebaseFirestore.instance
        .collection("notices")
        .where("branch", isEqualTo: branch)
        .snapshots();
  }

  getTasks(branch) {
    return FirebaseFirestore.instance
        .collection("tasks")
        .where("branch", isEqualTo: branch)
        .snapshots();
  }

  getChats(collection, groupId) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(groupId)
        .snapshots();
  }

  Future updateUser(roleCollection, userId, infoMap) async {
    await FirebaseFirestore.instance
        .collection(roleCollection)
        .doc(userId)
        .update(infoMap)
        .then((value) => print("user updated"));
  }

  Future addToOfficialGroup(branch, userId) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc("${branch}_official")
        .update({
      "members": FieldValue.arrayUnion([userId])
    }).then((value) => print("added to official"));
  }

  Future removeFromOfficialGroup(branch, userId) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc("${branch}_official")
        .update({
      "members": FieldValue.arrayRemove([userId])
    }).then((value) => print("member removed from official"));
  }
}
