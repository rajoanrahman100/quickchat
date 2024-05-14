import 'dart:developer';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:quick_chat/constants/app_colors.dart';
import 'package:quick_chat/constants/text_styles.dart';
import 'package:quick_chat/feature/chat_sceen/controller/chat_provider.dart';
import 'package:quick_chat/feature/push_notification/controller/notification_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String id;
  final String name;
  final String email;

  ChatScreen({super.key, required this.id, required this.name, required this.email});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(notificationProvider).getToken();
  }

/*  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      myToken = value.toString();
      log("My Token $myToken");
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void sendPusMessage(String token, String title, String body) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAA-UIAaQk:APA91bEKGm9xIR7I3OnxB7wUls64JVkNeB_YDczbOrFONhAFOBcufXT_29PuaviB-7D4cSKou_7_VSIO4urSTdOfVJ5zxHdRe414wOdKUe82Y2Km0jJHZLWLsZ1Z2AXG5qmxMJG1BZLT',
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title
            },
            'notification': <String, dynamic>{'title': title, 'body': body, 'android_channel_id': 'quick_chat'},
            'to': token,
          }));
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final chatNotifier = ref.watch(chatProvider);
    final notificationNotifier = ref.watch(notificationProvider);
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          widget.name,
          style: bodySemiBold14.copyWith(color: AppColors.kBSDark),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                    stream: chatNotifier.getMessages(widget.id, auth.currentUser!.uid),
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
                    })),
            Row(
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
                  onTap: () async {
                    DocumentSnapshot userSnapshot =
                        await FirebaseFirestore.instance.collection('user').doc(widget.id).get();
                    String fcmToken = userSnapshot['fcm'];
                    log("Receiver FCM $fcmToken");
                    chatNotifier.writeMessage(messageController, widget.id).then((value) {
                      notificationNotifier.sendPusMessage(fcmToken, widget.name, "New message");
                    });
                  },
                  child: const Icon(
                    Icons.send,
                    color: AppColors.kBSDark,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot data) {
    Map<String, dynamic> message = data.data() as Map<String, dynamic>;
    var alignment = (message['senderID'] == auth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;
    DateTime dateTime = message["timestamp"].toDate();
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (message["senderID"] == auth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment:
              (message["senderID"] == auth.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            message["senderID"] == auth.currentUser!.uid
                ? BubbleSpecialThree(
                    text: message["message"],
                    color: AppColors.white,
                    tail: true,
                    textStyle: bodyMedium14.copyWith(color: AppColors.kBSDark),
                  )
                : BubbleSpecialThree(
                    text: message["message"],
                    color: AppColors.white,
                    tail: true,
                    isSender: false,
                    textStyle: bodyMedium14.copyWith(color: AppColors.kBSDark),
                  ),
            Text(message["senderEmail"]),
          ],
        ),
      ),
    );
  }
}
