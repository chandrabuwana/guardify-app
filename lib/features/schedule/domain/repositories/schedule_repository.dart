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

  /// Get schedule detail by date using get_detail_schedule API
  Future<ShiftDetailResult> getScheduleDetail({
    required String userId,
    required DateTime date,
  });

  /// Get current shift using get_current API
  Future<CurrentShiftResult> getCurrentShift({
    required String userId,
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

  factory ShiftDetailResult.success(ShiftSchedule? shiftDetail) {
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

class CurrentShiftResult {
  final CurrentShiftData? currentShift;
  final Failure? failure;
  final bool isSuccess;

  const CurrentShiftResult._({
    this.currentShift,
    this.failure,
    required this.isSuccess,
  });

  factory CurrentShiftResult.success(CurrentShiftData currentShift) {
    return CurrentShiftResult._(
      currentShift: currentShift,
      isSuccess: true,
    );
  }

  factory CurrentShiftResult.failure(Failure failure) {
    return CurrentShiftResult._(
      failure: failure,
      isSuccess: false,
    );
  }
}

/// Entity for current shift data
class CurrentShiftData {
  final String id;
  final String name;
  final String startTime;
  final bool checkin;
  final bool checkout;
  final String? checkinTime;
  final String? checkoutTime;
  final List<CurrentShiftPersonnel> listPersonel;

  const CurrentShiftData({
    required this.id,
    required this.name,
    required this.startTime,
    required this.checkin,
    required this.checkout,
    this.checkinTime,
    this.checkoutTime,
    required this.listPersonel,
  });
}

class CurrentShiftPersonnel {
  final String userId;
  final String fullname;
  final String images;

  const CurrentShiftPersonnel({
    required this.userId,
    required this.fullname,
    required this.images,
  });
}
