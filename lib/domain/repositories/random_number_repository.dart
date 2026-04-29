import 'package:dartz/dartz.dart';
import 'package:tabla_mareas/core/errors/failures.dart';
import 'package:tabla_mareas/domain/entities/random_number.dart';

abstract class RandomNumberRepository {
  Future<Either<Failure, RandomNumber>> getRandomNumber();
}
