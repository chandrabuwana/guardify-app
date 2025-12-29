import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/constants/enums.dart';
import '../../domain/entities/laporan_kegiatan_entity.dart';
import '../../domain/repositories/laporan_kegiatan_repository.dart';
import '../datasources/laporan_kegiatan_remote_data_source.dart';

@LazySingleton(as: LaporanKegiatanRepository)
class LaporanKegiatanRepositoryImpl implements LaporanKegiatanRepository {
  final LaporanKegiatanRemoteDataSource remoteDataSource;

  LaporanKegiatanRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<LaporanKegiatanEntity>>> getLaporanList({
    LaporanStatus? status,
    UserRole? role,
    String? userId,
    String? search,
    int start = 1,
    int length = 10,
  }) async {
    try {
      final result = await remoteDataSource.getLaporanList(
        status: status,
        role: role,
        userId: userId,
        search: search,
        start: start,
        length: length,
      );
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure('Failed to get laporan list: $e'));
    }
  }

  @override
  Future<Either<Failure, LaporanKegiatanEntity>> getLaporanDetail(
      String id) async {
    try {
      final result = await remoteDataSource.getLaporanDetail(id);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to get laporan detail: $e'));
    }
  }

  @override
  Future<Either<Failure, LaporanKegiatanEntity>> updateStatusLaporan({
    required String id,
    required LaporanStatus status,
    required String reviewerId,
    required String reviewerName,
    String? umpanBalik,
  }) async {
    try {
      final result = await remoteDataSource.updateStatusLaporan(
        id: id,
        status: status,
        reviewerId: reviewerId,
        reviewerName: reviewerName,
        umpanBalik: umpanBalik,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to update laporan status: $e'));
    }
  }

  @override
  Future<Either<Failure, LaporanKegiatanEntity>> acceptLaporan(
      String id) async {
    return await updateStatusLaporan(
      id: id,
      status: LaporanStatus.verified,
      reviewerId: 'current_user_id', // Should be passed from context
      reviewerName: 'Current User',
    );
  }

  @override
  Future<Either<Failure, LaporanKegiatanEntity>> requestRevisi({
    required String id,
    required String note,
  }) async {
    return await updateStatusLaporan(
      id: id,
      status: LaporanStatus.revision,
      reviewerId: 'current_user_id', // Should be passed from context
      reviewerName: 'Current User',
      umpanBalik: note,
    );
  }

  @override
  Future<Either<Failure, List<LaporanKegiatanEntity>>> getMyLaporanList(
    String userId,
  ) async {
    return await getLaporanList(userId: userId);
  }

  @override
  Future<Either<Failure, List<LaporanKegiatanEntity>>>
      getSupervisedLaporanList({
    required String supervisorId,
    LaporanStatus? status,
  }) async {
    // For now, get all laporan; implement filtering logic based on hierarchy
    return await getLaporanList(status: status);
  }

  @override
  Future<Either<Failure, bool>> verifLaporan({
    required String idAttendance,
    required bool isVerif,
    String? feedback,
  }) async {
    try {
      final result = await remoteDataSource.verifLaporan(
        idAttendance: idAttendance,
        isVerif: isVerif,
        feedback: feedback,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Failed to verify laporan: $e'));
    }
  }
}
