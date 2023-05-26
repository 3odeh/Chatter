import 'package:chat_group/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import '../pages/auth/login_page.dart';
import 'database_service.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> _user;

  FirebaseAuth auth = FirebaseAuth.instance;
  late AppUser currentUser;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) async {
    await Future.delayed(const Duration(seconds: 1));
    if (user == null) {
      Get.offAll(() => const LoginPage());
    } else {
      DocumentSnapshot snapshot =
          await DatabaseService(uId: user.uid).gettingUserData();

      QuerySnapshot querySnapshot =
          await DatabaseService(uId: user.uid).gettingUserGroups();

      List<String> ids =[];
      for (var element in querySnapshot.docs) {ids.add(element.id);}

      print(ids);
      currentUser = AppUser(
          uId: snapshot.get("uId"),
          email: snapshot.get("email"),
          fullName: snapshot.get("fullName"),
          profilePicture: snapshot.get("profilePic"),
          groups: ids);
      Get.offAll(() => const HomePage());


    }
  }

  Future register(String fullName, email, password) async {
    try {
      User user = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        //call database
        await DatabaseService(uId: user.uid).savingUserData(fullName, email);
      }
    } on FirebaseAuthException catch (e) {
      _showSnackbar(e.message!);
    }
  }

  Future login(String email, password) async {
    try {
      (await auth.signInWithEmailAndPassword(email: email, password: password));
    } on FirebaseAuthException catch (e) {
      _showSnackbar(e.message!);
    }
  }

  Future signOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      _showSnackbar(e.message!);
    }
  }

  void _showSnackbar(String s) {
    Get.snackbar(
      "About User",
      "User message",
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
      backgroundColor: Colors.redAccent,
      titleText: const Text(
        "Account failed",
        style: TextStyle(color: Colors.white),
      ),
      messageText: Text(
        s,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
