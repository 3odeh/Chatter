import 'package:chat_group/models/user.dart';
import 'package:chat_group/pages/profile_page.dart';
import 'package:chat_group/pages/search_page.dart';
import 'package:chat_group/service/auth_service.dart';
import 'package:chat_group/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/group.dart';
import '../service/database_service.dart';
import '../widgets/group_dialog.dart';
import '../widgets/group_list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  final formKey = GlobalKey<AnimatedListState>();
  bool _isLoading = true;
  late AppUser user;

  List<GroupListTile> groupListTiles = [];
  late DatabaseService databaseService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = AuthController.instance.currentUser;
    databaseService = DatabaseService(uId: user.uId);
    getGroupData();
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
          "Chatter",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 27, letterSpacing: 1),
        ),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context,  SearchPage(currentUser: user));
              },
              icon: const Icon(
                Icons.search,
                size: 25,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            profileIcon(link: user.profilePicture, size: 150),
            const SizedBox(
              height: 15,
            ),
            Text(
              user.fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              onTap: () {},
              selectedColor: Colors.orange[900],
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              leading: const Icon(
                Icons.group,
                size: 30,
              ),
              title: const Text(
                "Groups",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(
                    context,
                    ProfilePage(
                      user: user,
                    ));
              },
              selectedColor: Colors.orange[900],
              selected: false,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              leading: const Icon(
                Icons.group,
                size: 30,
              ),
              title: const Text(
                "Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          onPopDialog(context);

          /*setState(() {
            _isLoading = true;
          });

          await DatabaseService(uId: user.uId)
              .savingGroupData("Test", user.fullName)
              .then((value) {
            setState(() {
              _isLoading = false;
            });
          });*/

          /*groupListTiles.add(groupListTile(appGroup: AppGroup(
              admin: "Abdallah",
              groupIcon: "",
              groupId: "109238 lkdf",
              groupName: "Testing",
              members: ["123sa"],
              recentMessage: "",
              recentMessageSender: ""),));
          formKey.currentState!.insertItem(0);*/
        },
        backgroundColor: Colors.orange[900],
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: Stack(
        children: [
          AnimatedList(
            key: formKey,
            initialItemCount: groupListTiles.length,
            itemBuilder:
                (BuildContext context, int index,  animation) {
              return SlideTransition(
                position: animation.drive(Tween<Offset>(
                    begin:  Offset(0,index + 1), end: const Offset(0, 0))),
                child: groupListTiles[index],
              );
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.5),
              alignment: Alignment.bottomCenter,
              child:  const Padding(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: CircularProgressIndicator(
                  color: Colors.redAccent,
                ),
              ),
            ),
        ],
      ),
    );
  }

  logout() async {
    setState(() {
      _isLoading = true;
    });
    await AuthController.instance.signOut().then((value) {});
  }

  onPopDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MyAlertDialog(
          user: user,
        );
      },
    );
  }

  bool isNotFirstTime = false;

  getGroupData() async {


    for (int x = 0; x < user.groups.length; x++) {
      QuerySnapshot snapshot =
      await DatabaseService().gettingGroupMembers(user.groups[x].trim());

      List<String> ids =[];
      for (var element in snapshot.docs) {ids.add(element.id);print("member :${element.id}");}
      await databaseService
          .gettingGroupData(user.groups[x].trim())
          .then((value) {
        DocumentSnapshot snapshot = value;
        AppGroup ag = AppGroup(
            admin: snapshot.get("admin"),
            groupIcon: snapshot.get("groupIcon"),
            groupId: snapshot.get("groupId"),
            groupName: snapshot.get("groupName"),
            members: ids,
            recentMessage: snapshot.get("recentMessage"),
            recentMessageSender: snapshot.get("recentMessageSender"));
        groupListTiles.add(GroupListTile(appGroup: ag,index: x,currentUser: user,));
      });

    }
    setState(() {
      _isLoading = false;
    });
    for (int x = 0; x < groupListTiles.length; x++) {
      await Future.delayed(const Duration(milliseconds: 500));
      formKey.currentState!.insertItem(x);
    }



       FirebaseFirestore.instance
        .collection("users")
        .doc(user.uId)
        .collection("groups")
        .snapshots()
        .listen((event) async {
          if(event.docs.isNotEmpty) {
            var change = event.docChanges[0];

            switch (change.type) {
              case DocumentChangeType.added:
                if (change.doc.data() != null ) {
                  
                  QuerySnapshot querySnapshot =
                  await DatabaseService().gettingGroupMembers(change.doc.id);
                  List<String> ids =[];
                  for (var element in querySnapshot.docs) {ids.add(element.id);}
                  await databaseService.gettingGroupData(change.doc.id).then((
                      value) {
                    DocumentSnapshot snapshot = value;

                    print(change.doc.id);

                    if (snapshot != null && snapshot.exists && isNotFirstTime) {

                      AppGroup ag = AppGroup(
                          admin: snapshot.get("admin"),
                          groupIcon: snapshot.get("groupIcon"),
                          groupId: snapshot.get("groupId"),
                          groupName: snapshot.get("groupName"),
                          members: ids,
                          recentMessage: snapshot.get("recentMessage"),
                          recentMessageSender: snapshot.get(
                              "recentMessageSender"));
                      user.groups.add(ag.groupId);
                      groupListTiles.add(GroupListTile(
                          appGroup: ag, index: groupListTiles.length - 1, currentUser: user,));
                      print("again");
                      formKey.currentState!.insertItem(
                          groupListTiles.length - 1);
                    }
                  });
                }
                break;
              case DocumentChangeType.removed:
                if (change.doc.data() != null) {
                  int index;
                  user.groups.removeWhere((element) => element == change.doc.id,);
                  groupListTiles.removeWhere((element) {
                    index = element.index;
                    return element.appGroup.groupId == change.doc.id;
                  });
                  formKey.currentState!.removeItem(
                      index = 0, (context, animation) =>
                      SlideTransition(
                        position: animation.drive(Tween<Offset>(
                            begin: const Offset(0, 0),
                            end: const Offset(0, 0))),
                        child: groupListTiles[index],
                      ));
                }
                break;
              case DocumentChangeType.modified:
                print("modified");
                break;
            }
          }else{
            if(groupListTiles.isNotEmpty) {
              formKey.currentState!.removeItem(
                  0, (context, animation) =>
                  SlideTransition(
                    position: animation.drive(Tween<Offset>(
                        begin: const Offset(0, 0),
                        end:  Offset.zero)),
                    child: null,
                  ));
              groupListTiles.clear();
            }
          }
          isNotFirstTime = true;
    });


  }
}
