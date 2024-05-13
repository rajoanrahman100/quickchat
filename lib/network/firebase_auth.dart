import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_chat/network/abstract/base_firebase_service.dart';

class FirebaseAuthClass extends BaseFirebaseService{

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  bool isUserLoggedIn() {
    // TODO: implement isUserLoggedIn
    if(auth.currentUser != null){
      return true;
    }else{
      return false;
    }

  }

  @override
  Future<UserCredential> loginUserWithFirebase(String path, String password) {
    // TODO: implement loginUserWithFirebase
    final credential = auth.signInWithEmailAndPassword(email: path, password: password);

    return credential;
  }

  @override
  void signOutUser() {
    auth.signOut();
  }

  @override
  Future<UserCredential> signUpUserWithFirebase(String path, String password, String name) {
    // TODO: implement signUpUserWithFirebase
    final credential = auth.createUserWithEmailAndPassword(email: path, password: password);
    return credential;
  }

}