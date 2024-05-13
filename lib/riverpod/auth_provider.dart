import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/network/firebase_auth.dart';
import 'package:quick_chat/network/firebase_service.dart';
import 'package:quick_chat/repository/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authRepositoryProvider).authStateChange;
});

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  UserCredential? _userCredential;
  Map<String, String> _userData = {};
  FirebaseAuthClass auth = FirebaseAuthClass();
  FireStoreService fstore = FireStoreService();

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
      _userCredential = await auth.signUpUserWithFirebase(email, password, name);
      final data = {"name": name, "email": email, "uid": _userCredential!.user!.uid, "password": password};
      bool isSuccess = await addUserToDatabase(data, "user", _userCredential!.user!.uid);
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

  void logOutUser(){
    auth.signOutUser();
  }

  setLoader(bool loader) {
    _isLoading = loader;
    notifyListeners();
  }
}
