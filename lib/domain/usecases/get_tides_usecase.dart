import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/location.dart';
import '../entities/tide_event.dart';
import '../repositories/tide_repository.dart';

class GetTidesUseCase {
  final TideRepository repository;

  GetTidesUseCase(this.repository);

  Future<Either<Failure, List<TideEvent>>> call(Location location, DateTime date) {
    return repository.getTides(location, date);
  }
}
