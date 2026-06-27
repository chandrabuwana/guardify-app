import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/test_result_entity.dart';
import '../../domain/entities/test_summary_entity.dart';
import '../../domain/entities/test_member_result_entity.dart';
import '../../domain/entities/assessment_entity.dart';
import '../../domain/repositories/test_result_repository.dart';
import '../datasources/test_result_remote_data_source.dart';

@LazySingleton(as: TestResultRepository)
class TestResultRepositoryImpl implements TestResultRepository {
  final TestResultRemoteDataSource remoteDataSource;

  TestResultRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<TestResultEntity>>> getMyResults(
      String userId, {int start = 1, int length = 20}) async {
    try {
      final results = await remoteDataSource.fetchMyResults(userId, start: start, length: length);
      final entities = results.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure('Failed to get exam results: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TestMemberResultEntity>>> getMemberResults({
    String? examId,
    String? jabatan,
  }) async {
    try {
      final results = await remoteDataSource.fetchMemberResults(
        examId: examId,
        jabatan: jabatan,
      );
      final entities = results.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure('Failed to get member results: $e'));
    }
  }

  @override
  Future<Either<Failure, TestSummaryEntity>> getExamSummary({
    String? userId,
    String? examId,
  }) async {
    try {
      final summary = await remoteDataSource.fetchExamSummary(
        userId: userId,
        examId: examId,
      );
      return Right(summary.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to get exam summary: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TestResultEntity>>> getMemberTestsByPic(
      String picId, {int start = 1, int length = 20}) async {
    try {
      final results = await remoteDataSource.fetchMemberTestsByPic(picId, start: start, length: length);
      final entities = results.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure('Failed to get member tests: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AssessmentEntity>>> getAssessmentList(
      String picId, {int start = 1, int length = 20}) async {
    try {
      final results = await remoteDataSource.fetchAssessmentList(picId, start: start, length: length);
      return Right(results);
    } catch (e) {
      return Left(ServerFailure('Failed to get assessment list: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TestResultEntity>>> getAssessmentDetail(
      String assessmentId, String idSpv, {int start = 1, int length = 20}) async {
    try {
      final results = await remoteDataSource.fetchAssessmentDetail(assessmentId, idSpv, start: start, length: length);
      final entities = results.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure('Failed to get assessment detail: $e'));
    }
  }
}

