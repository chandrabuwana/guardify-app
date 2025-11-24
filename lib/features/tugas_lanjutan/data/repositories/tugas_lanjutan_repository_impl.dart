import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/tugas_lanjutan_entity.dart';
import '../../domain/repositories/tugas_lanjutan_repository.dart';
import '../datasources/tugas_lanjutan_remote_data_source.dart';

@LazySingleton(as: TugasLanjutanRepository)
class TugasLanjutanRepositoryImpl implements TugasLanjutanRepository {
  final TugasLanjutanRemoteDataSource remoteDataSource;

  TugasLanjutanRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<TugasLanjutanEntity>>> getTugasLanjutanList({
    bool filterByToday = false,
    String? userId,
  }) async {
    try {
      final result = await remoteDataSource.getTugasLanjutanList(
        filterByToday: filterByToday,
        userId: userId,
      );
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TugasLanjutanEntity>> getTugasLanjutanDetail(
    String id,
  ) async {
    try {
      final result = await remoteDataSource.getTugasLanjutanDetail(id);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TugasLanjutanEntity>> selesaikanTugas({
    required String id,
    required String lokasi,
    required String buktiUrl,
    String? catatan,
    required String userId,
    required String userName,
  }) async {
    try {
      final result = await remoteDataSource.selesaikanTugas(
        id: id,
        lokasi: lokasi,
        buktiUrl: buktiUrl,
        catatan: catatan,
        userId: userId,
        userName: userName,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getProgressSummary({
    String? userId,
  }) async {
    try {
      final result = await remoteDataSource.getProgressSummary(userId: userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

