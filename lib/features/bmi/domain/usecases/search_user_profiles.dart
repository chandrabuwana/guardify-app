import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/entities/failure.dart';
import '../entities/user_profile.dart';
import '../repositories/bmi_repository.dart';

@injectable
class SearchUserProfiles {
  final BMIRepository repository;

  SearchUserProfiles(this.repository);

  Future<Either<Failure, List<UserProfile>>> call(String query) {
    if (query.trim().isEmpty) {
      return repository.getAllUserProfiles();
    }
    return repository.searchUserProfiles(query);
  }
}
