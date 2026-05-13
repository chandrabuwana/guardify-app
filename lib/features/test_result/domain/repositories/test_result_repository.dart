import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/test_result_entity.dart';
import '../entities/test_summary_entity.dart';
import '../entities/test_member_result_entity.dart';
import '../entities/assessment_entity.dart';

/// Repository interface untuk Test Result
abstract class TestResultRepository {
  /// Get hasil Test saya (user yang sedang login)
  Future<Either<Failure, List<TestResultEntity>>> getMyResults(String userId, {int start = 0, int length = 20});

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
      String picId, {int start = 0, int length = 20});

  /// Get assessment list (untuk Ujian Anggota tab)
  Future<Either<Failure, List<AssessmentEntity>>> getAssessmentList(
      String picId, {int start = 1, int length = 20});

  /// Get assessment detail (untuk Assessment Detail Page)
  Future<Either<Failure, List<TestResultEntity>>> getAssessmentDetail(
      String assessmentId, String idSpv, {int start = 1, int length = 20});
}
