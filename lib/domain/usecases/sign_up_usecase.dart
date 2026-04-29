import 'package:dartz/dartz.dart';
import 'package:tabla_mareas/core/errors/failures.dart';
import 'package:tabla_mareas/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  SignUpUseCase(this.repository);
  final AuthRepository repository;

  Future<Either<Failure, void>> call(String email, String password, {String? displayName}) =>
      repository.signUp(email, password, displayName: displayName);
}
