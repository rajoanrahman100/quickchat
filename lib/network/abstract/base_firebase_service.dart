import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseFirebaseService {
  Future<UserCredential> loginUserWithFirebase(String path, String password);

  Future<UserCredential> signUpUserWithFirebase(String path, String password, String name);

  void signOutUser();

  bool isUserLoggedIn();
}
