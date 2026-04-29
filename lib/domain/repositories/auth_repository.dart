import 'package:dartz/dartz.dart';
import 'package:tabla_mareas/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> signIn(String email, String password);
  Future<Either<Failure, void>> signUp(String email, String password, {String? displayName});
  Future<void> signOut();
  Future<Either<Failure, void>> resetPassword(String email);
  Stream<bool> get authStateChanges;
}
