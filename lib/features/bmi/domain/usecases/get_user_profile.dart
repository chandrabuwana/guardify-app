import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/entities/failure.dart';
import '../entities/user_profile.dart';
import '../repositories/bmi_repository.dart';

@injectable
class GetUserProfile {
  final BMIRepository repository;

  GetUserProfile(this.repository);

  Future<Either<Failure, UserProfile>> call(String userId) {
    return repository.getUserProfile(userId);
  }
}
