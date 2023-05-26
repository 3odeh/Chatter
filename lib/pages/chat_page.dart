import 'dart:math';

import 'package:chat_group/models/message.dart';
import 'package:chat_group/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/group.dart';
import '../models/user.dart';
import '../widgets/message_list_tile.dart';
import '../widgets/widgets.dart';
import 'info_page.dart';

class ChatPage extends StatefulWidget {
  final AppGroup appGroup;
  final AppUser currentUser;

  const ChatPage({Key? key, required this.appGroup, required this.currentUser})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final formTextFieldKey = GlobalKey<FormState>();
  var sendController = TextEditingController();
  final formKey = GlobalKey<AnimatedListState>();
  List<MessageListTile> messageListTiles = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.orange[900],
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.appGroup.groupName,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 27, letterSpacing: 1),
        ),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    InfoPage(
                      appGroup: widget.appGroup,
                      currentUser: widget.currentUser,
                    ));
              },
              icon: const Icon(
                Icons.info,
                size: 25,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20)),
        ],
      ),
      body: Form(
        key: formTextFieldKey,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ...messageListTiles,
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),

            // AnimatedList(
            //   key: formKey,
            //   initialItemCount: messageListTiles.length,
            //   itemBuilder:
            //       (BuildContext context, int index, Animation<double> animation) {
            //     return SlideTransition(
            //       position: animation.drive(Tween<Offset>(
            //           begin: const Offset(1, 0), end: const Offset(0, 0))),
            //       child: messageListTiles[index],
            //     );
            //   },
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 80,
                  color: Colors.grey[800],
                  padding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextFormField(
                            validator: (v) {
                              return (v!.isEmpty)
                                  ? "The message is empty"
                                  : null;
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: sendController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Send a message...",
                              hintStyle: TextStyle(color: Colors.white,
                                  fontSize: 16),
                            ),
                          )),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.orange[900],
                        child: IconButton(
                          onPressed: () {
                            sendMessage();
                          },
                          icon: const Icon(
                            Icons.send,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool isNotFirstTime = false;

  getAllMessages() async {
    QuerySnapshot snapshot =
    await DatabaseService().gettingGroupMessages(widget.appGroup.groupId);

    for (var x in snapshot.docs) {
      AppMessage message = AppMessage(
          messageId: x.id,
          messageContent: x.get("messageContent"),
          messageTime: x.get("messageTime"),
          userId: x.get("userId"),
          userName: x.get("userName"));


      setState(() {
        messageListTiles.add(MessageListTile(
          index: messageListTiles.length - 1,
          title: message.userName,
          subtitle: message.messageContent,
          time: message.messageTime.toDate(),
          isMe: (widget.currentUser.uId == message.userId),
        ));
      });
    }
    FirebaseFirestore.instance
        .collection("groups")
        .doc(widget.appGroup.groupId)
        .collection("messages")
        .snapshots()
        .listen((event) async {
      if (event.docChanges.isNotEmpty) {
        var change = event.docChanges[0];

        switch (change.type) {
          case DocumentChangeType.added:
            if (change.doc.data() != null && isNotFirstTime) {
              print(change.doc.id.split("_")[0].trim());
              DocumentSnapshot snapshot = change.doc;

              AppMessage message = AppMessage(
                  messageId: snapshot.get("messageId"),
                  messageContent: snapshot.get("messageContent"),
                  messageTime: snapshot.get("messageTime"),
                  userId: snapshot.get("userId"),
                  userName: snapshot.get("userName"));

              setState(() {
                messageListTiles.add(MessageListTile(
                    index: messageListTiles.length - 1,
                    title: message.userName,
                    subtitle: message.messageContent,
                    time: message.messageTime.toDate(),
                    isMe: (widget.currentUser.uId == message.userId)));
              });
            }
            break;

          case DocumentChangeType.removed:
            print("removed");
            break;
          case DocumentChangeType.modified:
            print("modified");
            break;
        }
      } else {}
      isNotFirstTime = true;
    });
  }

  sendMessage() async {
    if (formTextFieldKey.currentState!.validate()) {
      AppMessage message = AppMessage(messageId: "",
          messageContent: sendController.text,
          messageTime: Timestamp.now(),
          userId: widget.currentUser.uId,
          userName: widget.currentUser.fullName);
      await DatabaseService().setGroupMessages(
          widget.appGroup.groupId, message);
    }
  }
}
