import 'package:dartz/dartz.dart';
import 'package:tabla_mareas/core/errors/failures.dart';
import 'package:tabla_mareas/domain/repositories/auth_repository.dart';

class SignInUseCase {
  SignInUseCase(this.repository);
  final AuthRepository repository;

  Future<Either<Failure, void>> call(String email, String password) =>
      repository.signIn(email, password);
}
