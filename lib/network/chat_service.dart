import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/constants/app_assets.dart';
import 'package:quick_chat/model/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fstore = FirebaseFirestore.instance;

  // Send Message
  Future<void> sendMessage(String receiverID, String message) async {
    //Get current user info
    String currentUserID = _auth.currentUser!.uid;
    String currentUserEmail = _auth.currentUser!.email!;
    Timestamp timestamp = Timestamp.now();
    //Create a new message
    Message newMessage =
        Message(senderID: currentUserID, senderEmail: currentUserEmail, message: message, receiverID: receiverID, timestamp: timestamp);

    //construct current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); //sort the ids
    String chatRoomID = ids.join("-"); //combine the ids into a single stream to use as a chat room id

    await _fstore.collection(AppAssets.userCollection).doc(chatRoomID).collection(AppAssets.messageCollection).add(newMessage.toMap());
  }

  // Get Message

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join("-");

    return _fstore
        .collection(AppAssets.userCollection)
        .doc(chatRoomID)
        .collection(AppAssets.messageCollection)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  void writeMessage(TextEditingController messageController, id) async {
    if (messageController.text.isNotEmpty) {
      await sendMessage(id, messageController.text);
      messageController.clear();
    }
  }
}
