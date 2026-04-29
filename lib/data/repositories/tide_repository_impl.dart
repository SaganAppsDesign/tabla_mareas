import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/tide_event.dart';
import '../../domain/repositories/tide_repository.dart';
import '../datasources/tide_remote_data_source.dart';

class TideRepositoryImpl implements TideRepository {
  final TideRemoteDataSource remoteDataSource;

  TideRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TideEvent>>> getTides(Location location, DateTime date) async {
    try {
      final tides = await remoteDataSource.getTides(location, date);
      return Right(tides);
    } catch (e) {
      return const Left(NetworkFailure('Error fetching tides from server'));
    }
  }
}
