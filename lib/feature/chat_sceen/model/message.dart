import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String senderName;
  final String message;
  final String receiverID;
  final Timestamp timestamp;

  Message(
      {required this.senderID,
      required this.senderEmail,
      required this.senderName,
      required this.message,
      required this.receiverID,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'senderName': senderName,
      'message': message,
      'receiverID': receiverID,
      'timestamp': timestamp
    };
  }
}
