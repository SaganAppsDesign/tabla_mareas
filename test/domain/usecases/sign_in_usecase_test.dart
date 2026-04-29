import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabla_mareas/core/errors/failures.dart';
import 'package:tabla_mareas/domain/repositories/auth_repository.dart';
import 'package:tabla_mareas/domain/usecases/sign_in_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignInUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = SignInUseCase(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  test(
    'should call signIn from the repository',
    () async {
      // arrange
      when(() => mockAuthRepository.signIn(any(), any()))
          .thenAnswer((_) async => const Right(null));
      
      // act
      final result = await useCase(tEmail, tPassword);

      // assert
      expect(result, const Right(null));
      verify(() => mockAuthRepository.signIn(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'should return a Failure when the repository call is unsuccessful',
    () async {
      // arrange
      const tFailure = FirebaseFailure('Invalid credentials');
      when(() => mockAuthRepository.signIn(any(), any()))
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await useCase(tEmail, tPassword);

      // assert
      expect(result, const Left(tFailure));
      verify(() => mockAuthRepository.signIn(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
