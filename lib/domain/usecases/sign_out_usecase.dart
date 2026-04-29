import 'package:tabla_mareas/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  SignOutUseCase(this.repository);
  final AuthRepository repository;

  Future<void> call() => repository.signOut();
}
