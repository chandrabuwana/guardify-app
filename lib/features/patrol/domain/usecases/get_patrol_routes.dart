import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/patrol_route.dart';
import '../repositories/patrol_repository.dart';

@injectable
class GetPatrolRoutes {
  final PatrolRepository repository;

  GetPatrolRoutes(this.repository);

  Future<Either<Failure, List<PatrolRoute>>> call() async {
    return await repository.getPatrolRoutes();
  }
}