import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabla_mareas/core/usecases/usecase.dart';
import 'package:tabla_mareas/domain/entities/random_number.dart';
import 'package:tabla_mareas/domain/repositories/random_number_repository.dart';
import 'package:tabla_mareas/domain/usecases/get_random_number_usecase.dart';

class MockRandomNumberRepository extends Mock
    implements RandomNumberRepository {}

void main() {
  late GetRandomNumberUseCase usecase;
  late MockRandomNumberRepository mockRepository;

  setUp(() {
    mockRepository = MockRandomNumberRepository();
    usecase = GetRandomNumberUseCase(mockRepository);
  });

  final tRandomNumber = RandomNumber(value: 42);

  test('should get random number from the repository', () async {
    // arrange
    when(
      () => mockRepository.getRandomNumber(),
    ).thenAnswer((_) async => Right(tRandomNumber));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, Right(tRandomNumber));
    verify(() => mockRepository.getRandomNumber());
    verifyNoMoreInteractions(mockRepository);
  });
}
