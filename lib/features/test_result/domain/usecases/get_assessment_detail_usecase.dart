import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/test_result_entity.dart';
import '../repositories/test_result_repository.dart';

@injectable
class GetAssessmentDetailUseCase {
  final TestResultRepository repository;

  GetAssessmentDetailUseCase(this.repository);

  Future<Either<Failure, List<TestResultEntity>>> call(String assessmentId, String idSpv, {int start = 1, int length = 20}) {
    return repository.getAssessmentDetail(assessmentId, idSpv, start: start, length: length);
  }
}
