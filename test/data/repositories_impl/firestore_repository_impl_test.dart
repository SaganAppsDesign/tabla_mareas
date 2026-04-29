import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabla_mareas/core/errors/failures.dart';
import 'package:tabla_mareas/data/datasources/firestore_remote_data_source.dart';
import 'package:tabla_mareas/data/repositories_impl/firestore_repository_impl.dart';

class MockFirestoreRemoteDataSource extends Mock
    implements FirestoreRemoteDataSource {}

void main() {
  late FirestoreRepositoryImpl repository;
  late MockFirestoreRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockFirestoreRemoteDataSource();
    repository = FirestoreRepositoryImpl(mockRemoteDataSource);
  });

  const tCollection = 'test';
  const tData = {'key': 'value'};

  group('saveData', () {
    test(
      'should return Right(null) when call to remote data source is successful',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.addDocument(any(), any()),
        ).thenAnswer((_) async => {});

        // act
        final result = await repository.saveData(tCollection, tData);

        // assert
        expect(result, const Right(null));
        verify(() => mockRemoteDataSource.addDocument(tCollection, tData));
      },
    );

    test(
      'should return FirestoreFailure when call to remote data source fails',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.addDocument(any(), any()),
        ).thenThrow(Exception('Firestore Error'));

        // act
        final result = await repository.saveData(tCollection, tData);

        // assert
        expect(result, isA<Left<Failure, void>>());
        result.fold(
          (failure) => expect(failure, isA<FirestoreFailure>()),
          (_) => fail('Should have returned a Failure'),
        );
      },
    );
  });

  group('getData', () {
    test('should return document data when successful', () async {
      // arrange
      // Note: In a real scenario, we'd mock DocumentSnapshot,
      // but for repository unit tests we focus on the mapping logic.
      // Since the repo calls dataSource.getDocument, we'll mock that.
    });
  });
}
