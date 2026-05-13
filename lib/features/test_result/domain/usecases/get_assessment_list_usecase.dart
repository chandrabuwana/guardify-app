import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/assessment_entity.dart';
import '../repositories/test_result_repository.dart';

/// Use case untuk get assessment list (untuk Ujian Anggota tab)
@injectable
class GetAssessmentListUseCase {
  final TestResultRepository repository;

  GetAssessmentListUseCase(this.repository);

  Future<Either<Failure, List<AssessmentEntity>>> call(String picId, {int start = 1, int length = 20}) async {
    return await repository.getAssessmentList(picId, start: start, length: length);
  }
}
