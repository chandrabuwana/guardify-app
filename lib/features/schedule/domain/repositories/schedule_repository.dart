import '../entities/shift_schedule.dart';
import '../../../../core/error/failures.dart';

/// Repository contract untuk schedule
abstract class ScheduleRepository {
  /// Get monthly schedule untuk user
  Future<ScheduleResult> getMonthlySchedule({
    required String userId,
    required int year,
    required int month,
  });

  /// Get shift detail by date
  Future<ShiftDetailResult> getShiftDetail({
    required String userId,
    required DateTime date,
  });

  /// Get daily agenda untuk kalender view
  Future<DailyAgendaResult> getDailyAgenda({
    required String userId,
    required int year,
    required int month,
  });
}

// Custom Result Classes

class ScheduleResult {
  final List<ShiftSchedule>? schedules;
  final Failure? failure;
  final bool isSuccess;

  const ScheduleResult._({
    this.schedules,
    this.failure,
    required this.isSuccess,
  });

  factory ScheduleResult.success(List<ShiftSchedule> schedules) {
    return ScheduleResult._(
      schedules: schedules,
      isSuccess: true,
    );
  }

  factory ScheduleResult.failure(Failure failure) {
    return ScheduleResult._(
      failure: failure,
      isSuccess: false,
    );
  }
}

class ShiftDetailResult {
  final ShiftSchedule? shiftDetail;
  final Failure? failure;
  final bool isSuccess;

  const ShiftDetailResult._({
    this.shiftDetail,
    this.failure,
    required this.isSuccess,
  });

  factory ShiftDetailResult.success(ShiftSchedule shiftDetail) {
    return ShiftDetailResult._(
      shiftDetail: shiftDetail,
      isSuccess: true,
    );
  }

  factory ShiftDetailResult.failure(Failure failure) {
    return ShiftDetailResult._(
      failure: failure,
      isSuccess: false,
    );
  }
}

class DailyAgendaResult {
  final List<DailyAgenda>? agendas;
  final Failure? failure;
  final bool isSuccess;

  const DailyAgendaResult._({
    this.agendas,
    this.failure,
    required this.isSuccess,
  });

  factory DailyAgendaResult.success(List<DailyAgenda> agendas) {
    return DailyAgendaResult._(
      agendas: agendas,
      isSuccess: true,
    );
  }

  factory DailyAgendaResult.failure(Failure failure) {
    return DailyAgendaResult._(
      failure: failure,
      isSuccess: false,
    );
  }
}
