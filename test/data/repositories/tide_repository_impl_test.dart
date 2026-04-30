import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:tabla_mareas/core/errors/failures.dart';
import 'package:tabla_mareas/data/datasources/tide_remote_data_source.dart';
import 'package:tabla_mareas/data/models/tide_event_model.dart';
import 'package:tabla_mareas/data/repositories/tide_repository_impl.dart';
import 'package:tabla_mareas/domain/entities/location.dart';
import 'package:tabla_mareas/domain/entities/tide_event.dart';

class MockTideRemoteDataSource extends Mock implements TideRemoteDataSource {}
class FakeLocation extends Fake implements Location {}

void main() {
  late TideRepositoryImpl repository;
  late MockTideRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    registerFallbackValue(FakeLocation());
  });

  setUp(() {
    mockRemoteDataSource = MockTideRemoteDataSource();
    repository = TideRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tLocation = const Location(id: '1', name: 'Test', latitude: 0, longitude: 0);
  final tDate = DateTime.now();
  final tTideModels = [
    TideEventModel(time: tDate, height: 1, type: TideType.high)
  ];
  final List<TideEvent> tTides = tTideModels;

  test('debe retornar lista de mareas exitosamente', () async {
    when(() => mockRemoteDataSource.getTides(any(), any()))
        .thenAnswer((_) async => tTideModels);

    final result = await repository.getTides(tLocation, tDate);

    expect(result, Right(tTides));
    verify(() => mockRemoteDataSource.getTides(tLocation, tDate)).called(1);
    verifyNoMoreInteractions(mockRemoteDataSource);
  });

  test('debe retornar NetworkFailure cuando ocurre una excepcion', () async {
    when(() => mockRemoteDataSource.getTides(any(), any()))
        .thenThrow(Exception('Error'));

    final result = await repository.getTides(tLocation, tDate);

    expect(result, const Left(NetworkFailure('Error fetching tides from server')));
    verify(() => mockRemoteDataSource.getTides(tLocation, tDate)).called(1);
    verifyNoMoreInteractions(mockRemoteDataSource);
  });
}
