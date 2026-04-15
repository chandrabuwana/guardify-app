import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/patrol_location.dart';
import '../repositories/patrol_repository.dart';

class AddPatrolLocationParams {
  final String routeId;
  final PatrolLocation location;

  AddPatrolLocationParams({
    required this.routeId,
    required this.location,
  });
}

@injectable
class AddPatrolLocation {
  final PatrolRepository repository;

  AddPatrolLocation(this.repository);

  Future<Either<Failure, PatrolLocation>> call(AddPatrolLocationParams params) async {
    return await repository.addPatrolLocation(params.routeId, params.location);
  }
}