

import 'package:chat_group/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../models/group.dart';
import '../models/user.dart';
import '../pages/chat_page.dart';

class GroupListTile extends StatefulWidget {
  final AppGroup appGroup;
  final AppUser currentUser;
  final int index;
  const GroupListTile({Key? key, required this.appGroup, required this.index, required this.currentUser}) : super(key: key);

  @override
  State<GroupListTile> createState() => _GroupListTileState();
}

class _GroupListTileState extends State<GroupListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListTile(
        onTap:() {

          nextScreen(context,  ChatPage(appGroup:widget.appGroup, currentUser: widget.currentUser,));

        },
        dense: true,
        leading: CircleAvatar(
            backgroundColor: Colors.orange[900],
            radius: 25,
            child: Text(widget.appGroup.groupName.trim().substring(0, 1).toUpperCase())),
        title: Text(widget.appGroup.groupName.trim(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        subtitle:  Text("Join the conversation as ${widget.appGroup.admin.trim()}",style: const TextStyle(fontSize: 16,)),
      ),
    );
  }
}
