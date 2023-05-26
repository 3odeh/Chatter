

import 'package:flutter/material.dart';


class MemberListTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final int index;
  final bool isAdmin;
  const MemberListTile({Key? key, required this.index, required this.isAdmin, required this.title, required this.subtitle}) : super(key: key);

  @override
  State<MemberListTile> createState() => _MemberListTileState();
}

class _MemberListTileState extends State<MemberListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
      child: Container(

        height:100,
        decoration: (widget.isAdmin) ? BoxDecoration(borderRadius: BorderRadius.circular(30),color:Colors.orange[900]?.withOpacity(0.2) ) : null,
        child: Center(
          child: ListTile(
            onTap:() {

            },

            leading: CircleAvatar(
                backgroundColor: Colors.orange[900],
                radius: 30,
                child: Text(widget.title.trim().substring(0, 1).toUpperCase())),
            title: Text(widget.title.trim(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            subtitle:  Text(widget.subtitle,style:  TextStyle(fontSize: 16,color: (widget.isAdmin) ? Colors.black: null)),
          ),
        ),
      ),
    );
  }
}
