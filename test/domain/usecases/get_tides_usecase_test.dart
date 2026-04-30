import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:tabla_mareas/core/errors/failures.dart';
import 'package:tabla_mareas/domain/entities/location.dart';
import 'package:tabla_mareas/domain/entities/tide_event.dart';
import 'package:tabla_mareas/domain/repositories/tide_repository.dart';
import 'package:tabla_mareas/domain/usecases/get_tides_usecase.dart';

class MockTideRepository extends Mock implements TideRepository {}
class FakeLocation extends Fake implements Location {}

void main() {
  late GetTidesUseCase useCase;
  late MockTideRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeLocation());
  });

  setUp(() {
    mockRepository = MockTideRepository();
    useCase = GetTidesUseCase(mockRepository);
  });

  final tLocation = const Location(id: '1', name: 'Test', latitude: 0, longitude: 0);
  final tDate = DateTime.now();
  final tTides = [
    TideEvent(time: tDate, height: 1, type: TideType.high)
  ];

  test('debe retornar lista de mareas del repositorio', () async {
    when(() => mockRepository.getTides(any(), any()))
        .thenAnswer((_) async => Right(tTides));

    final result = await useCase(tLocation, tDate);

    expect(result, Right(tTides));
    verify(() => mockRepository.getTides(tLocation, tDate)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('debe retornar Failure del repositorio', () async {
    when(() => mockRepository.getTides(any(), any()))
        .thenAnswer((_) async => const Left(ServerFailure('Error')));

    final result = await useCase(tLocation, tDate);

    expect(result, const Left(ServerFailure('Error')));
    verify(() => mockRepository.getTides(tLocation, tDate)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
