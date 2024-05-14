import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/constants/app_assets.dart';
import 'package:quick_chat/model/user_model.dart';
import 'package:quick_chat/network/firebase_auth.dart';
import 'package:quick_chat/network/firebase_service.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  UserCredential? _userCredential;
  Map<String, String> _userData = {};
  FirebaseAuthClass auth = FirebaseAuthClass();
  FireStoreService fstore = FireStoreService();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  List<ChatUser>? _users;

  List<ChatUser>? get users => _users;

  bool get isLoading => _isLoading;

  UserCredential? get userCredential => _userCredential;

  Map<String, String> get userData => _userData;

  Future<UserCredential> loginUserWithFirebase(String email, String password) async {
    setLoader(true);
    try {
      _userCredential = await auth.loginUserWithFirebase(email, password);
      setLoader(false);
      return _userCredential!;
    } catch (e) {
      print(e);
      setLoader(false);
      return Future.error(e);
    }
  }

  Future<UserCredential> signUpUserWithFirebase(String email, String password, String name) async {
    setLoader(true);
    try {
      final fcmToken = await getTheFCM();
      _userCredential = await auth.signUpUserWithFirebase(email, password, name);
      final data = {"name": name, "email": email, "uid": _userCredential!.user!.uid, "password": password, "fcm": fcmToken};
      bool isSuccess = await addUserToDatabase(data, AppAssets.userCollection, _userCredential!.user!.uid);
      if (isSuccess) {
        setLoader(false);
        return _userCredential!;
      } else {
        setLoader(false);
        throw Exception("Something went wrong");
      }
    } catch (e) {
      print(e);
      setLoader(false);
      return Future.error(e);
    }
  }

  Future<List<ChatUser>> fetchUserFromFirebase(String collectionName) async {
    try {
      QuerySnapshot querySnapshot = await fstore.getUserDataFromFireStore(collectionName);
      _users = querySnapshot.docs.map((doc) => ChatUser.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      log(_users!.length.toString());
      return _users!;
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  Future<bool> addUserToDatabase(Map<String, String> userData, String collectionName, String docName) async {
    var value = false;

    try {
      fstore.addDataToFirebase(userData, collectionName, docName);
      value = true;
    } catch (e) {
      print(e);
      value = false;
    }

    return value;
  }

  Future<String> getTheFCM() async {
     // Change here
    String? fcmToken = await firebaseMessaging.getToken();
    return fcmToken!;
  }

  void logOutUser() {
    auth.signOutUser();
    firebaseMessaging.deleteToken();
  }

  setLoader(bool loader) {
    _isLoading = loader;
    notifyListeners();
  }
}
