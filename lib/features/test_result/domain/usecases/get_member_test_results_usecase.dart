import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/test_member_result_entity.dart';
import '../repositories/test_result_repository.dart';

/// Use case untuk get hasil Test anggota
@injectable
class GetMemberTestResultsUseCase {
  final TestResultRepository repository;

  GetMemberTestResultsUseCase(this.repository);

  Future<Either<Failure, List<TestMemberResultEntity>>> call({
    String? examId,
    String? jabatan,
  }) async {
    return await repository.getMemberResults(
      examId: examId,
      jabatan: jabatan,
    );
  }
}

