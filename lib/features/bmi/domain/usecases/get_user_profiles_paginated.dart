import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/entities/failure.dart';
import '../entities/user_profile.dart';
import '../../../../core/domain/entities/paginated_response.dart';
import '../repositories/bmi_repository.dart';

@injectable
class GetUserProfilesPaginated {
  final BMIRepository repository;

  GetUserProfilesPaginated(this.repository);

  Future<Either<Failure, PaginatedResponse<UserProfile>>> call({
    required int page,
    int pageSize = 10,
  }) async {
    return await repository.getUserProfilesPaginated(
      page: page,
      pageSize: pageSize,
    );
  }
}
