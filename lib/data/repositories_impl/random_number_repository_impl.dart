import 'package:dartz/dartz.dart';
import 'package:tabla_mareas/core/errors/failures.dart';
import 'package:tabla_mareas/data/datasources/random_number_remote_data_source.dart';
import 'package:tabla_mareas/domain/entities/random_number.dart';
import 'package:tabla_mareas/domain/repositories/random_number_repository.dart';

class RandomNumberRepositoryImpl implements RandomNumberRepository {
  RandomNumberRepositoryImpl({required this.remoteDataSource});
  final RandomNumberRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, RandomNumber>> getRandomNumber() async {
    try {
      final result = await remoteDataSource.getRandomNumber();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
