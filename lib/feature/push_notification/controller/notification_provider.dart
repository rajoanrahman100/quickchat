import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final notificationProvider = ChangeNotifierProvider<NotificationProvider>((ref) {
  return NotificationProvider();
});

class NotificationProvider extends ChangeNotifier {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String _token = "";

  String get token => _token;

  void getToken() async {
    await messaging.getToken().then((value) {
      _token = value.toString();
    });
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
  }
}
