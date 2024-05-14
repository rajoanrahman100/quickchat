import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/constants/app_assets.dart';
import 'package:quick_chat/constants/app_colors.dart';
import 'package:quick_chat/constants/context_extention.dart';
import 'package:quick_chat/constants/text_styles.dart';
import 'package:quick_chat/feature/chat_sceen/chat_screen.dart';
import 'package:quick_chat/feature/login_screen/login_screen.dart';
import 'package:quick_chat/main.dart';
import 'package:quick_chat/model/user_model.dart';
import 'package:quick_chat/riverpod/auth_provider.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // ref.read(authProvider).fetchUserFromFirebase(AppAssets.userCollection);
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification!.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //               channel.id, channel.name, channelDescription: channel.description,
    //               color: Colors.blue,
    //               playSound: true,
    //               icon: '@mipmap/ic_launcher'),
    //         ));
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text(
          "Quick Chat",
          style: bodySemiBold14.copyWith(color: AppColors.kBSDark),
        ),
        actions: [
          Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final authNotifier = ref.watch(authProvider);
            return IconButton(
              onPressed: () {
                authNotifier.logOutUser();
                context.navigateToScreen(isReplaced: true, child: LoginScreen());
              },
              icon: const Icon(Icons.logout),
            );
          })
        ],
      ),
      body: FutureBuilder(
        future: ref.read(authProvider).fetchUserFromFirebase(AppAssets.userCollection),
        builder: (BuildContext context, AsyncSnapshot<List<ChatUser>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: AppColors.black,
              color: AppColors.surfaceColor,
            ));
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  ChatUser user = snapshot.data![index];
                  return auth.currentUser!.email != user.email
                      ? GestureDetector(
                          onTap: () {
                            context.navigateToScreen(child: ChatScreen(id: user.id, name: user.name, email: user.email));
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              title: Text(
                                user.name,
                                style: bodySemiBold16,
                              ),
                              subtitle: Text(user.email),
                              trailing: const Icon(
                                Icons.chat,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        )
                      : Container();
                });
          }
        },
      ),
    );
  }
}
