import 'package:chat_group/models/group.dart';
import 'package:chat_group/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uId;

  DatabaseService({this.uId});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  Future savingUserData(String fullName, email) async {
    return await userCollection.doc(uId).set({
      "fullName": fullName,
      "email": email,
      "profilePic": "",
      "uId": uId,
    });
  }

  Future gettingUserData() async {
    DocumentSnapshot snapshot = await userCollection.doc(uId).get();
    return snapshot;
  }

  Future gettingUserGroups() async {
    QuerySnapshot snapshot =
        await userCollection.doc(uId).collection("groups").get();
    return snapshot;
  }



  Future savingGroupData(String groupName, fullName) async {
    DocumentReference documentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${uId}_$fullName",
      "members": "${uId}_$fullName",
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    documentReference.update({"groupId": documentReference.id});

    // await userCollection.doc(uId).update({
    //   "groups": FieldValue.arrayUnion([documentReference.id])
    // });
    await userCollection
        .doc(uId)
        .collection("groups")
        .doc(documentReference.id)
        .set({"admin": true});

    groupCollection
        .doc(documentReference.id)
        .collection("members")
        .doc("${uId}_$fullName")
        .set({"admin": true});
    return documentReference;
  }

  Future gettingGroupData(String groupId) async {
    DocumentSnapshot snapshot = (await groupCollection.doc(groupId).get());
    return snapshot;
  }

  Future gettingSearchedGroupsData(String nameGroup) async {
    QuerySnapshot snapshot =
        await groupCollection.where("groupName", isEqualTo: nameGroup).get();
    return snapshot;
  }

  Future gettingGroupMembers(groupId) async {
    QuerySnapshot snapshot =
        await groupCollection.doc(groupId).collection("members").get();
    return snapshot;
  }
  Future gettingGroupMessages(groupId) async {
    QuerySnapshot snapshot =
    await groupCollection.doc(groupId).collection("messages").orderBy("messageTime",descending: false).get();
    return snapshot;
  }
  Future setGroupMessages(groupId,AppMessage message) async {

    DocumentReference documentReference =  await groupCollection.doc(groupId).collection("messages").add({
      "messageContent":message.messageContent,
      "messageId":message.messageId,
      "messageTime":message.messageTime,
      "userId":message.userId,
      "userName":message.userName,
    });
    await documentReference.update({"messageId":documentReference.id});
  }

  getAllChats(String groupId) {
    return groupCollection
        .doc(groupId)
        .collection("massages")
        .orderBy("time")
        .snapshots();
  }

  leaveTheGroup(AppGroup group,String name) async {
    await userCollection
        .doc(uId)
        .collection("groups")
        .doc(group.groupId)
        .delete();

    await groupCollection
        .doc(group.groupId)
        .collection("members")
        .doc("${uId}_$name")
        .delete();
  }

  joinGroup(String groupId,String name) async {
    await userCollection
        .doc(uId)
        .collection("groups")
        .doc(groupId)
        .set({"admin": false});

    await groupCollection
        .doc(groupId)
        .collection("members")
        .doc("${uId}_$name")
        .set({"admin": false});
  }
}
