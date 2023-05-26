import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          const SizedBox(
            height: 80,
          ),
          const Text(
            "Chatter",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 50,
              color: Colors.black,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.none
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Image.asset("assets/login.png"),
          const SizedBox(
            height: 150,
          ),
          const  CircularProgressIndicator(
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}
