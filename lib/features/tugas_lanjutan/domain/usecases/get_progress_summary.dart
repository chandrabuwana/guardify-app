import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/tugas_lanjutan_repository.dart';

/// Use case untuk get progress summary
@injectable
class GetProgressSummary {
  final TugasLanjutanRepository repository;

  GetProgressSummary(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    String? userId,
  }) async {
    return await repository.getProgressSummary(userId: userId);
  }
}

