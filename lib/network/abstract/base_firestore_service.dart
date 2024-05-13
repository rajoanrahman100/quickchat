abstract class BaseFireStoreService {
  Future<void> addDataToFirebase(Map<String, dynamic> data,String collectionName,String docName);
  Future<void> updateDataToFirebase(Map<String, dynamic> data,String collectionName,String docName);
  Future<void> getUserDataFromFireStore(String collectionName,String docName);

}