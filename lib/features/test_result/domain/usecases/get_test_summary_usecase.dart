import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/test_summary_entity.dart';
import '../repositories/test_result_repository.dart';

/// Use case untuk get ringkasan hasil Test
@injectable
class GetTestSummaryUseCase {
  final TestResultRepository repository;

  GetTestSummaryUseCase(this.repository);

  Future<Either<Failure, TestSummaryEntity>> call({
    String? userId,
    String? examId,
  }) async {
    return await repository.getExamSummary(
      userId: userId,
      examId: examId,
    );
  }
}

