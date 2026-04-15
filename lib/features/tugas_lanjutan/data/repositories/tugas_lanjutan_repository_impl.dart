import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/tugas_lanjutan_entity.dart';
import '../../domain/repositories/tugas_lanjutan_repository.dart';
import '../datasources/tugas_lanjutan_remote_data_source.dart';
import '../../../schedule/domain/usecases/get_current_task.dart';
import '../../../schedule/domain/usecases/get_current_shift.dart';

@LazySingleton(as: TugasLanjutanRepository)
class TugasLanjutanRepositoryImpl implements TugasLanjutanRepository {
  final TugasLanjutanRemoteDataSource remoteDataSource;
  final GetCurrentTask getCurrentTask;
  final GetCurrentShift getCurrentShift;

  TugasLanjutanRepositoryImpl(
    this.remoteDataSource,
    this.getCurrentTask,
    this.getCurrentShift,
  );

  @override
  Future<Either<Failure, List<TugasLanjutanEntity>>> getTugasLanjutanList({
    bool filterByToday = false,
    String? userId,
    bool filterByJabatan = false,
    String? jabatan,
    String? status,
  }) async {
    try {
      if (filterByToday) {
        // Tab "Hari Ini": Get from get_current_task
        if (userId == null) {
          return Left(ServerFailure('userId is required'));
        }

        // First, get current shift to get idShiftDetail
        final shiftResult = await getCurrentShift(userId: userId);
        if (!shiftResult.isSuccess || shiftResult.currentShift == null) {
          // No shift today, return empty list
          return const Right([]);
        }

        final shift = shiftResult.currentShift!;
        final idShiftDetail = shift.idShiftDetail ?? shift.id;

        // Get current task using idShiftDetail
        final taskResult = await getCurrentTask(idShiftDetail: idShiftDetail);
        if (!taskResult.isSuccess || taskResult.currentTask == null) {
          return const Right([]);
        }

        // Convert ListCarryOver to TugasLanjutanEntity
        final carryOverTasks = taskResult.currentTask!.listCarryOver;
        
        // Check if listCarryOver is null or empty
        if (carryOverTasks.isEmpty) {
          return const Right([]);
        }
        
        final tugasList = carryOverTasks.asMap().entries.map((entry) {
          final index = entry.key;
          final task = entry.value;
          final reportDate = task.reportDate != null
              ? DateTime.tryParse(task.reportDate!)
              : null;
          final solverDate = task.solverDate != null
              ? DateTime.tryParse(task.solverDate!)
              : null;
          final status = task.status.toUpperCase() == 'OPEN'
              ? TugasLanjutanStatus.belum
              : TugasLanjutanStatus.selesai;

          return TugasLanjutanEntity(
            id: task.id,
            title: 'Tugas Lanjutan ${index + 1}',
            lokasi: task.location ?? '',
            pelapor: task.createBy ?? 'Unknown',
            tanggal: reportDate ?? DateTime.now(),
            deskripsi: task.reportNote.isNotEmpty
                ? task.reportNote
                : 'Tugas lanjutan',
            status: status,
            diselesaikanOleh: (task.solver?.fullname != null &&
                    task.solver!.fullname!.trim().isNotEmpty)
                ? task.solver!.fullname!.trim()
                : (task.solverId != null
                    ? '${task.updateBy ?? task.solverId}'
                    : null),
            diselesaikanOlehId: task.solverId,
            tanggalSelesai: solverDate,
            buktiUrl: task.evidenceUrl ?? task.file,
            catatan: task.solverNote,
          );
        }).toList();

        return Right(tugasList);
      } else {
        // Tab "Riwayat" or "Tugas Anggota": Get from CarriedOverTask/list API
        final result = await remoteDataSource.getTugasLanjutanList(
          filterByToday: false,
          userId: userId,
          filterByJabatan: filterByJabatan,
          jabatan: jabatan,
          status: status,
        );
        return Right(result.map((model) => model.toEntity()).toList());
      }
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
      if (userId == null) {
        return Left(ServerFailure('userId is required'));
      }

      // Get current shift to get idShiftDetail
      final shiftResult = await getCurrentShift(userId: userId);
      if (!shiftResult.isSuccess || shiftResult.currentShift == null) {
        // No shift today, return empty summary
        return const Right({
          'total': 0,
          'selesai': 0,
          'belum': 0,
          'terverifikasi': 0,
          'progress': 0.0,
        });
      }

      final shift = shiftResult.currentShift!;
      final idShiftDetail = shift.idShiftDetail ?? shift.id;

      // Get current task using idShiftDetail
      final taskResult = await getCurrentTask(idShiftDetail: idShiftDetail);
      if (!taskResult.isSuccess || taskResult.currentTask == null) {
        // No task data, return empty summary
        return const Right({
          'total': 0,
          'selesai': 0,
          'belum': 0,
          'terverifikasi': 0,
          'progress': 0.0,
        });
      }

      // Calculate summary from ListCarryOver
      final carryOverTasks = taskResult.currentTask!.listCarryOver;
      final total = carryOverTasks.length;
      final selesai = carryOverTasks
          .where((task) => task.status.toUpperCase() != 'OPEN')
          .length;
      final belum = carryOverTasks
          .where((task) => task.status.toUpperCase() == 'OPEN')
          .length;
      final terverifikasi = 0; // Not available in current API response

      return Right({
        'total': total,
        'selesai': selesai,
        'belum': belum,
        'terverifikasi': terverifikasi,
        'progress': total > 0 ? selesai / total : 0.0,
      });
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

