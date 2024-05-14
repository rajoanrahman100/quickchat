import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quick_chat/constants/app_colors.dart';
import 'package:quick_chat/constants/text_styles.dart';
import 'package:quick_chat/network/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String id;
  final String name;
  final String email;

  ChatScreen({super.key, required this.id, required this.name, required this.email});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ChatService chatService = ChatService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(widget.id, messageController.text);
      messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          widget.email,
          style: bodySemiBold14.copyWith(color: AppColors.kBSDark),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: chatService.getMessages(widget.id, auth.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          return ListView(
            children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot data) {
    Map<String, dynamic> message = data.data() as Map<String, dynamic>;
    var alignment = (message['senderID'] == auth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (message["senderID"] == auth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: (message["senderID"] == auth.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(message["senderEmail"]),
            Text(message["message"]),
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            style: bodyMedium14.copyWith(color: AppColors.kBSDark),
            controller: messageController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "write your message here",
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              fillColor: AppColors.white,
              border: OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
        const Gap(10.0),
        GestureDetector(
          onTap: () {
            sendMessage();
          },
          child: const Icon(
            Icons.send,
            color: AppColors.kBSDark,
            size: 30,
          ),
        ),
      ],
    );
  }
}
