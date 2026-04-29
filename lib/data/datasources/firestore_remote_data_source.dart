import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreRemoteDataSource {
  Future<void> addDocument(String collectionPath, Map<String, dynamic> data);
  Future<void> updateDocument(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data,
  );
  Future<void> deleteDocument(String collectionPath, String documentId);
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String collectionPath,
    String documentId,
  );
  Stream<QuerySnapshot<Map<String, dynamic>>> getCollectionStream(
    String collectionPath,
  );
}

class FirestoreRemoteDataSourceImpl implements FirestoreRemoteDataSource {
  FirestoreRemoteDataSourceImpl(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<void> addDocument(
    String collectionPath,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(collectionPath).add(data);
  }

  @override
  Future<void> updateDocument(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(collectionPath).doc(documentId).update(data);
  }

  @override
  Future<void> deleteDocument(String collectionPath, String documentId) async {
    await _firestore.collection(collectionPath).doc(documentId).delete();
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String collectionPath,
    String documentId,
  ) async {
    return await _firestore.collection(collectionPath).doc(documentId).get();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getCollectionStream(
    String collectionPath,
  ) {
    return _firestore.collection(collectionPath).snapshots();
  }
}
