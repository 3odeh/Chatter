import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/group.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 2)),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 2)),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent, width: 2)),
);

void nextScreen(context, page) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ));
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
          label: "OK", onPressed: () {}, textColor: Colors.black),
    ),
  );
}

Widget profileIcon({required String link, required double size}) {
  // if (link.isURL) {
  //   // return Image(
  //   //   height: size,
  //   //   width: size,
  //   //   fit: BoxFit.fill,
  //   //   image: NetworkImage(link),
  //   // );
  // } else {
  //   return Icon(
  //     Icons.account_circle,
  //     size: size,
  //   );

  return Icon(
    Icons.account_circle,
    size: size,
  );
}

// Widget memberListTile({required String title,required String subtitle,required bool isAdmin}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
//     child: Container(
//
//       height:100,
//       decoration: (isAdmin) ? BoxDecoration(borderRadius: BorderRadius.circular(30),color:Colors.orange[900]?.withOpacity(0.2) ) : null,
//       child: Center(
//         child: ListTile(
//           onTap:() {
//
//           },
//
//           leading: CircleAvatar(
//               backgroundColor: Colors.orange[900],
//               radius: 30,
//               child: Text(title.trim().substring(0, 1).toUpperCase())),
//           title: Text(title.trim(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
//           subtitle:  Text(subtitle,style:  TextStyle(fontSize: 16,color: (isAdmin) ? Colors.black: null)),
//         ),
//       ),
//     ),
//   );
// }
