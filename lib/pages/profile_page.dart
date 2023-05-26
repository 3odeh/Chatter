import 'package:chat_group/pages/home_page.dart';
import 'package:chat_group/pages/search_page.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../service/auth_service.dart';
import '../widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  final AppUser user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: Colors.orange[900],
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Profile",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 27, letterSpacing: 1),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    logout();
                  },
                  icon: const Icon(
                    Icons.logout,
                    size: 25,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20)),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 50),
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 150,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.user.fullName,
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
                  onTap: () {
                    nextScreenReplace(context, const HomePage());
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
                    "Groups",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
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
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                profileIcon(link: widget.user.profilePicture, size: 200),
                const SizedBox(
                  height: 80,
                ),

                Flexible(
                  child: Text(
                    widget.user.fullName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                Flexible(
                  child: Text(
                    widget.user.email,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Scaffold(
            backgroundColor: Colors.white.withOpacity(0.5),
            body: const Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            ),
          ),
      ],
    );
  }

  logout() async {
    setState(() {
      _isLoading = true;
    });
    await AuthController.instance.signOut().then((value) {});
  }
}
