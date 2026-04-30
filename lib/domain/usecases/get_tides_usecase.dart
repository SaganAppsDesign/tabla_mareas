import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/location.dart';
import '../entities/tide_event.dart';
import '../repositories/tide_repository.dart';

class GetTidesUseCase {
  GetTidesUseCase(this.repository);

  final TideRepository repository;

  Future<Either<Failure, List<TideEvent>>> call(Location location, DateTime date) {
    return repository.getTides(location, date);
  }
}
