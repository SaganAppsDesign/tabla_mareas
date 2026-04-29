import 'package:dartz/dartz.dart';
import 'package:tabla_mareas/core/errors/failures.dart';
import 'package:tabla_mareas/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  ResetPasswordUseCase(this.repository);
  final AuthRepository repository;

  Future<Either<Failure, void>> call(String email) =>
      repository.resetPassword(email);
}
