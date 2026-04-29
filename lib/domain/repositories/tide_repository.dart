import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/location.dart';
import '../entities/tide_event.dart';

abstract class TideRepository {
  Future<Either<Failure, List<TideEvent>>> getTides(Location location, DateTime date);
}
