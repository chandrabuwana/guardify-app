import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/entities/failure.dart';
import '../entities/user_profile.dart';
import '../repositories/bmi_repository.dart';

@injectable
class GetUserProfilesPaginated {
  final BMIRepository repository;

  GetUserProfilesPaginated(this.repository);

  Future<Either<Failure, List<UserProfile>>> call({
    required int page,
    int pageSize = 10,
  }) async {
    return await repository.getUserProfilesPaginated(
      page: page,
      pageSize: pageSize,
    );
  }
}
