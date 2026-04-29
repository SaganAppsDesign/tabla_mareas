import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabla_mareas/data/datasources/firestore_remote_data_source.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreRemoteDataSourceImpl dataSource;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    dataSource = FirestoreRemoteDataSourceImpl(fakeFirestore);
  });

  const tCollection = 'test_collection';
  const tData = {'name': 'Test Item', 'value': 123};

  group('addDocument', () {
    test('should add a document to the collection', () async {
      // act
      await dataSource.addDocument(tCollection, tData);

      // assert
      final snapshot = await fakeFirestore.collection(tCollection).get();
      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first.data(), tData);
    });
  });

  group('getDocument', () {
    test('should retrieve a document by id', () async {
      // arrange
      final docRef = await fakeFirestore.collection(tCollection).add(tData);

      // act
      final result = await dataSource.getDocument(tCollection, docRef.id);

      // assert
      expect(result.data(), tData);
      expect(result.id, docRef.id);
    });
  });

  group('updateDocument', () {
    test('should update an existing document', () async {
      // arrange
      final docRef = await fakeFirestore.collection(tCollection).add(tData);
      const newData = {'value': 456};

      // act
      await dataSource.updateDocument(tCollection, docRef.id, newData);

      // assert
      final updatedDoc = await fakeFirestore
          .collection(tCollection)
          .doc(docRef.id)
          .get();
      expect(updatedDoc.data()?['value'], 456);
      expect(
        updatedDoc.data()?['name'],
        tData['name'],
      ); // Should merge/update properly based on Firestore behavior
    });
  });

  group('deleteDocument', () {
    test('should remove a document', () async {
      // arrange
      final docRef = await fakeFirestore.collection(tCollection).add(tData);

      // act
      await dataSource.deleteDocument(tCollection, docRef.id);

      // assert
      final doc = await fakeFirestore
          .collection(tCollection)
          .doc(docRef.id)
          .get();
      expect(doc.exists, false);
    });
  });
}
