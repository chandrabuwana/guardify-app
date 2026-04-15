import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/patrol_repository.dart';

class VerifyLocationParams {
  final double currentLatitude;
  final double currentLongitude;
  final double targetLatitude;
  final double targetLongitude;

  VerifyLocationParams({
    required this.currentLatitude,
    required this.currentLongitude,
    required this.targetLatitude,
    required this.targetLongitude,
  });
}

@injectable
class VerifyLocation {
  final PatrolRepository repository;

  VerifyLocation(this.repository);

  Future<Either<Failure, bool>> call(VerifyLocationParams params) async {
    return await repository.verifyLocation(
      params.currentLatitude,
      params.currentLongitude,
      params.targetLatitude,
      params.targetLongitude,
    );
  }
}