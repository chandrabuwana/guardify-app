import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/entities/failure.dart';
import '../entities/user_profile.dart';
import '../repositories/bmi_repository.dart';

@injectable
class ManagePinnedProfiles {
  final BMIRepository repository;

  ManagePinnedProfiles(this.repository);

  Future<Either<Failure, List<UserProfile>>> getPinnedProfiles() {
    return repository.getPinnedUserProfiles();
  }

  Future<Either<Failure, void>> togglePin(String userId, bool isPinned) {
    return repository.togglePinUserProfile(userId, isPinned);
  }
}
