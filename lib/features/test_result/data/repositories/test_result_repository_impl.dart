import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/test_result_entity.dart';
import '../../domain/entities/test_summary_entity.dart';
import '../../domain/entities/test_member_result_entity.dart';
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
      String userId) async {
    try {
      final results = await remoteDataSource.fetchMyResults(userId);
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
      String picId) async {
    try {
      final results = await remoteDataSource.fetchMemberTestsByPic(picId);
      final entities = results.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure('Failed to get member tests: $e'));
    }
  }
}

