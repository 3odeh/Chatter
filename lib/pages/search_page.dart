import 'package:chat_group/models/user.dart';
import 'package:chat_group/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/group.dart';
import '../widgets/search_group_list_tile.dart';

class SearchPage extends StatefulWidget {
  final AppUser currentUser;

  const SearchPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var searchController = TextEditingController();
  List<AppGroup> groups = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.orange[900],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Search",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 27, letterSpacing: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: Colors.orange[900],
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search groups...",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )),
                IconButton(
                  onPressed: () {
                    searchGroups();
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          ...groups.map((e) {
            bool hasJoined = widget.currentUser.groups.where((element) {
              return element == e.groupId;
            }).isNotEmpty;

            return SearchListTile(
                title: e.groupName,
                subtitle: "Admin: ${e.admin}",
                hasJoined: hasJoined,
                join: DatabaseService(uId: widget.currentUser.uId)
                    .joinGroup(e.groupId,widget.currentUser.fullName));
          }),
        ]),
      ),
    );
  }

  searchGroups() async {
    QuerySnapshot snapshot = await DatabaseService()
        .gettingSearchedGroupsData(searchController.text);

    setState(() {
      groups.clear();
    });
    for (int x = 0; x < snapshot.docs.length; x++) {
      AppGroup ag = AppGroup(
          admin: snapshot.docs[x]["admin"],
          groupIcon: snapshot.docs[x]["groupIcon"],
          groupId: snapshot.docs[x]["groupId"],
          groupName: snapshot.docs[x]["groupName"],
          members: [],
          recentMessage: snapshot.docs[x]["recentMessage"],
          recentMessageSender: snapshot.docs[x]["recentMessageSender"]);
      setState(() {
        groups.add(ag);
      });
    }
  }
}
