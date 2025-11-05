import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../datasources/schedule_remote_data_source.dart';

@LazySingleton(as: ScheduleRepository)
class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ScheduleResult> getMonthlySchedule({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      final models = await remoteDataSource.getMonthlySchedule(
        userId: userId,
        year: year,
        month: month,
      );

      final schedules = models.map((model) => model.toEntity()).toList();

      return ScheduleResult.success(schedules);
    } on DioException catch (e) {
      if (e.response?.statusCode != null &&
          e.response!.statusCode! >= 400 &&
          e.response!.statusCode! < 500) {
        return ScheduleResult.failure(
          AuthenticationFailure('Gagal memuat jadwal'),
        );
      }
      return ScheduleResult.failure(
        ServerFailure('Terjadi kesalahan pada server'),
      );
    } catch (e) {
      return ScheduleResult.failure(
        UnexpectedFailure(e.toString()),
      );
    }
  }

  @override
  Future<ShiftDetailResult> getShiftDetail({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final model = await remoteDataSource.getShiftDetail(
        userId: userId,
        date: date,
      );

      if (model == null) {
        return ShiftDetailResult.failure(
          CacheFailure('Tidak ada shift untuk tanggal ini'),
        );
      }

      final shiftDetail = model.toEntity();

      return ShiftDetailResult.success(shiftDetail);
    } on DioException catch (e) {
      if (e.response?.statusCode != null &&
          e.response!.statusCode! >= 400 &&
          e.response!.statusCode! < 500) {
        return ShiftDetailResult.failure(
          AuthenticationFailure('Gagal memuat detail shift'),
        );
      }
      return ShiftDetailResult.failure(
        ServerFailure('Terjadi kesalahan pada server'),
      );
    } catch (e) {
      return ShiftDetailResult.failure(
        UnexpectedFailure(e.toString()),
      );
    }
  }

  @override
  Future<DailyAgendaResult> getDailyAgenda({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      final models = await remoteDataSource.getDailyAgenda(
        userId: userId,
        year: year,
        month: month,
      );

      final agendas = models.map((model) => model.toEntity()).toList();

      return DailyAgendaResult.success(agendas);
    } on DioException catch (e) {
      if (e.response?.statusCode != null &&
          e.response!.statusCode! >= 400 &&
          e.response!.statusCode! < 500) {
        return DailyAgendaResult.failure(
          AuthenticationFailure('Gagal memuat agenda'),
        );
      }
      return DailyAgendaResult.failure(
        ServerFailure('Terjadi kesalahan pada server'),
      );
    } catch (e) {
      return DailyAgendaResult.failure(
        UnexpectedFailure(e.toString()),
      );
    }
  }
}
