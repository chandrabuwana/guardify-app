import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/test_result_entity.dart';
import '../entities/test_summary_entity.dart';
import '../entities/test_member_result_entity.dart';

/// Repository interface untuk Test Result
abstract class TestResultRepository {
  /// Get hasil Test saya (user yang sedang login)
  Future<Either<Failure, List<TestResultEntity>>> getMyResults(String userId);

  /// Get hasil Test anggota (untuk PJO/Deputy/Pengawas/Danton)
  Future<Either<Failure, List<TestMemberResultEntity>>> getMemberResults({
    String? examId,
    String? jabatan,
  });

  /// Get ringkasan hasil Test
  Future<Either<Failure, TestSummaryEntity>> getExamSummary({
    String? userId,
    String? examId,
  });

  /// Get hasil Test anggota berdasarkan PIC ID (untuk Danton)
  Future<Either<Failure, List<TestResultEntity>>> getMemberTestsByPic(
      String picId);
}
