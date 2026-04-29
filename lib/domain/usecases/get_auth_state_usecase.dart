import 'package:tabla_mareas/domain/repositories/auth_repository.dart';

class GetAuthStateUseCase {
  GetAuthStateUseCase(this.repository);
  final AuthRepository repository;

  Stream<bool> call() => repository.authStateChanges;
}
