import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/patrol_progress.dart';
import '../repositories/patrol_repository.dart';

@injectable
class GetPatrolProgress {
  final PatrolRepository repository;

  GetPatrolProgress(this.repository);

  Future<Either<Failure, PatrolProgress>> call(String routeId) async {
    return await repository.getPatrolProgress(routeId);
  }
}