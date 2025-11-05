import 'package:injectable/injectable.dart';
import '../entities/cuti_entity.dart';
import '../repositories/cuti_repository.dart';

class UpdateStatusCutiParams {
  final String cutiId;
  final CutiStatus status;
  final String reviewerId;
  final String reviewerName;
  final String? umpanBalik;

  UpdateStatusCutiParams({
    required this.cutiId,
    required this.status,
    required this.reviewerId,
    required this.reviewerName,
    this.umpanBalik,
  });
}

@injectable
class UpdateStatusCuti {
  final CutiRepository repository;

  UpdateStatusCuti(this.repository);

  Future<CutiEntity> call(UpdateStatusCutiParams params) async {
    return await repository.updateStatusCuti(
      cutiId: params.cutiId,
      status: params.status,
      reviewerId: params.reviewerId,
      reviewerName: params.reviewerName,
      umpanBalik: params.umpanBalik,
    );
  }
}
