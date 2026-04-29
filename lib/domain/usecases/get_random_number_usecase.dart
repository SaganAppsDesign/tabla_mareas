import 'package:dartz/dartz.dart';
import 'package:tabla_mareas/core/errors/failures.dart';
import 'package:tabla_mareas/core/usecases/usecase.dart';
import 'package:tabla_mareas/domain/entities/random_number.dart';
import 'package:tabla_mareas/domain/repositories/random_number_repository.dart';

class GetRandomNumberUseCase extends UseCase<RandomNumber, NoParams> {
  GetRandomNumberUseCase(this.repository);
  final RandomNumberRepository repository;

  @override
  Future<Either<Failure, RandomNumber>> call(NoParams params) {
    return repository.getRandomNumber();
  }
}
