import 'package:cloud_firestore/cloud_firestore.dart';

class AppMessage {
  final String messageId;
  final String messageContent;
  final Timestamp messageTime;
  final String userId;
  final String userName;

  AppMessage(
      {required this.messageId,
      required this.messageContent,
      required this.messageTime,
      required this.userId,
      required this.userName});
}
