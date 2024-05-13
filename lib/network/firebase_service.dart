import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_chat/network/abstract/base_firestore_service.dart';

class FireStoreService extends BaseFireStoreService {
  final _fireStore = FirebaseFirestore.instance;

  @override
  Future<void> addDataToFirebase(Map<String, dynamic> data, String collectionName, String docName) async {
    try {
      await _fireStore.collection(collectionName).doc(docName).set(data);
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateDataToFirebase(Map<String, dynamic> data, String collectionName, String docName) async {
    try {
      await _fireStore
          .collection(collectionName)
          .doc(docName)
          .update(data)
          .then((value) => print("Updated"))
          .catchError((error) => print("Failed $error"));
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> getUserDataFromFireStore(String collectionName, String docName) async {
    // TODO: implement getUserDataFromFireStore
    try {
      final userData = await _fireStore.collection(collectionName).doc(docName).get();
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }
}
