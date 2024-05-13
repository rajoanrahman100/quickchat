import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/constants/app_theme.dart';
import 'package:quick_chat/helper/firebase_options.dart';
import 'package:quick_chat/ui/home_screen.dart';
import 'package:quick_chat/ui/login_screen/login_screen.dart';
import 'package:quick_chat/ui/sign_up_screen/signup_screen.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme(),
      home: FirebaseAuth.instance.currentUser != null ? HomeScreen() : LoginScreen(),

    );
  }
}

