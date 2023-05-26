import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/group.dart';
import '../models/user.dart';
import '../service/database_service.dart';
import '../widgets/member_list_tile.dart';

class InfoPage extends StatefulWidget {
  final AppGroup appGroup;
  final AppUser currentUser;

  const InfoPage({Key? key, required this.appGroup, required this.currentUser})
      : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<MemberListTile> memberListTiles = [];

  final formKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    memberListTiles.add(MemberListTile(
      title: "Group: ${widget.appGroup.groupName}",
      subtitle: "Admin: ${widget.appGroup.admin}",
      isAdmin: true,
      index: 0,
    ));
    getMemberData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.orange[900],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Group Info",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 27, letterSpacing: 1),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                //nextScreen(context,  InfoPage(appGroup:widget.appGroup));
                await DatabaseService(uId: widget.currentUser.uId)
                    .leaveTheGroup(widget.appGroup,widget.currentUser.fullName);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.group_remove_outlined,
                size: 25,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20)),
        ],
      ),
      body: AnimatedList(
        key: formKey,
        initialItemCount: memberListTiles.length,
        itemBuilder:
            (BuildContext context, int index, Animation<double> animation) {
          return SlideTransition(
            position: animation.drive(Tween<Offset>(
                begin: const Offset(1, 0), end: const Offset(0, 0))),
            child: memberListTiles[index],
          );
        },
      ),
    );
  }


  bool isNotFirstTime = false;

  getMemberData() async {
    QuerySnapshot snapshot =
    await DatabaseService().gettingGroupMembers(widget.appGroup.groupId.trim());

    widget.appGroup.members.clear();
    for (var element in snapshot.docs) { widget.appGroup.members.add(element.id);print("member :${element.id}");}


    for (int i = 0; i < widget.appGroup.members.length; i++) {

      List tmp = widget.appGroup.members[i].split("_");
      print(widget.appGroup.members[i]);
      if(tmp != null && tmp.isNotEmpty) {
        print(tmp);
        String name =  tmp[1];
        String id =  tmp[0];
        memberListTiles.add(MemberListTile(
          title: name,
          subtitle: id,
          isAdmin: false,
          index: memberListTiles.length - 1,
        ));
      }else{
        print("error");
      }
      formKey.currentState!.insertItem(memberListTiles.length - 1);
    }

    FirebaseFirestore.instance
        .collection("groups")
        .doc(widget.appGroup.groupId)
        .collection("members")
        .snapshots()
        .listen((event) async {
      if (event.docChanges.isNotEmpty) {
        var change = event.docChanges[0];

        switch (change.type) {
          case DocumentChangeType.added:
            if (change.doc.data() != null&& isNotFirstTime) {
              print(change.doc.id.split("_")[0].trim());
              DocumentSnapshot snapshot =
                  await DatabaseService(uId: change.doc.id.split("_")[0].trim())
                      .gettingUserData();

              AppUser user = AppUser(
                  uId: snapshot.get("uId"),
                  email: snapshot.get("email"),
                  fullName: snapshot.get("fullName"),
                  profilePicture: snapshot.get("profilePic"),
                  groups: []);

              memberListTiles.add(MemberListTile(
                title: user.fullName,
                subtitle: user.uId,
                isAdmin: false,
                index: memberListTiles.length - 1,
              ));
              formKey.currentState!.insertItem(memberListTiles.length - 1);
            }
            break;

          case DocumentChangeType.removed:
            if (change.doc.data() != null) {
              int index = 0;
              print("DocumentChangeType.removed: ${change.doc.id}");
              memberListTiles.removeWhere((element) {
                index = element.index;
                return "${element.subtitle}_${element.title}"== change.doc.id;
              });

              formKey.currentState!.removeItem(
                  index,
                  (context, animation) => SlideTransition(
                        position: animation.drive(Tween<Offset>(
                            begin: const Offset(0, 0),
                            end: const Offset(0, 0))),
                        child: memberListTiles[index],
                      ));
            }
            break;
          case DocumentChangeType.modified:
            print("modified");
            break;
        }
      }else{
        if(memberListTiles.isNotEmpty) {
          formKey.currentState!.removeItem(
              0, (context, animation) =>
              SlideTransition(
                position: animation.drive(Tween<Offset>(
                    begin: const Offset(0, 0),
                    end:  Offset.zero)),
                child: null,
              ));
          memberListTiles.clear();
        }
      }
      isNotFirstTime = true;
    });
  }
}
