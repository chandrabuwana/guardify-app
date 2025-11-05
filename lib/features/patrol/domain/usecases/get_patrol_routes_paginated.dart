import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/domain/entities/paginated_response.dart';
import '../entities/patrol_route.dart';
import '../repositories/patrol_repository.dart';

@injectable
class GetPatrolRoutesPaginated {
  final PatrolRepository repository;

  GetPatrolRoutesPaginated(this.repository);

  Future<Either<Failure, PaginatedResponse<PatrolRoute>>> call({
    required int page,
    required int pageSize,
  }) async {
    return await repository.getPatrolRoutesPaginated(
      page: page,
      pageSize: pageSize,
    );
  }
}
