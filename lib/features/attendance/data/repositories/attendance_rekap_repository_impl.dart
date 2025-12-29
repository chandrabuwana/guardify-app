import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/attendance_rekap_request_entity.dart';
import '../../domain/entities/attendance_rekap_response_entity.dart';
import '../../domain/entities/attendance_rekap_detail_response_entity.dart';
import '../../domain/entities/attendance_update_request.dart';
import '../../domain/repositories/attendance_rekap_repository.dart';
import '../datasources/attendance_rekap_remote_data_source.dart';

@Injectable(as: AttendanceRekapRepository)
class AttendanceRekapRepositoryImpl implements AttendanceRekapRepository {
  final AttendanceRekapRemoteDataSource remoteDataSource;

  AttendanceRekapRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AttendanceRekapResponseEntity>> getRekap(
      AttendanceRekapRequestEntity request) async {
    try {
      final result = await remoteDataSource.getRekap(request);
      return Right(result.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, AttendanceRekapDetailResponseEntity>> getDetail(
      String idAttendance) async {
    try {
      final result = await remoteDataSource.getDetail(idAttendance);
      return Right(result.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateAttendance(
      AttendanceUpdateRequest request) async {
    try {
      await remoteDataSource.updateAttendance(request);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  Failure _handleException(dynamic exception) {
    final errorMessage = exception.toString();
    if (errorMessage.contains('Network') || errorMessage.contains('network')) {
      return NetworkFailure(errorMessage);
    } else if (errorMessage.contains('Unauthorized') ||
        errorMessage.contains('unauthorized')) {
      return const AuthenticationFailure('Session expired');
    } else if (errorMessage.contains('Forbidden') ||
        errorMessage.contains('forbidden')) {
      return const AuthorizationFailure('Access denied');
    } else if (errorMessage.contains('Bad request') ||
        errorMessage.contains('bad request')) {
      return ValidationFailure(errorMessage);
    } else {
      return ServerFailure(errorMessage);
    }
  }
}

