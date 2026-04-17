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

  /// Get current task using get_current_task API
  Future<CurrentTaskResult> getCurrentTask({
    required String idShiftDetail,
  });

  /// Get schedule pengawas using get_schedule_pengawas API
  Future<ShiftDetailResult> getSchedulePengawas({
    required DateTime date,
  });

  /// Get shift now using get_shift_now API (for pengawas)
  Future<ShiftNowResult> getShiftNow();
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
  final String? idShiftDetail;
  final String? shiftDate;
  final String? location;
  final bool isOnLeave;

  const CurrentShiftData({
    required this.id,
    required this.name,
    required this.startTime,
    required this.checkin,
    required this.checkout,
    this.checkinTime,
    this.checkoutTime,
    required this.listPersonel,
    this.idShiftDetail,
    this.shiftDate,
    this.location,
    this.isOnLeave = false,
  });
}

class CurrentShiftPersonnel {
  final String userId;
  final String fullname;
  final String? images;

  const CurrentShiftPersonnel({
    required this.userId,
    required this.fullname,
    this.images,
  });
}

class CurrentTaskResult {
  final CurrentTaskData? currentTask;
  final Failure? failure;
  final bool isSuccess;

  const CurrentTaskResult._({
    this.currentTask,
    this.failure,
    required this.isSuccess,
  });

  factory CurrentTaskResult.success(CurrentTaskData currentTask) {
    return CurrentTaskResult._(
      currentTask: currentTask,
      isSuccess: true,
    );
  }

  factory CurrentTaskResult.failure(Failure failure) {
    return CurrentTaskResult._(
      failure: failure,
      isSuccess: false,
    );
  }
}

/// Entity for current task data
class CurrentTaskData {
  final List<RouteTask> listRoute;
  final List<CarryOverTask> listCarryOver;

  const CurrentTaskData({
    required this.listRoute,
    required this.listCarryOver,
  });
}

/// Route Task Entity
class RouteTask {
  final String idAreas;
  final String areasName;
  final String? routeName;
  final String? checkIn;
  final String? filename;
  final String? fileUrl;
  final String status;
  final double? latitude;
  final double? longitude;

  const RouteTask({
    required this.idAreas,
    required this.areasName,
    this.routeName,
    this.checkIn,
    this.filename,
    this.fileUrl,
    required this.status,
    this.latitude,
    this.longitude,
  });
}

/// Carry Over Task Entity
class CarryOverTask {
  final String id;
  final String createBy;
  final String createDate;
  final String idShift;
  final String reportDate;
  final String reportId;
  final String reportNote;
  final String? solverDate;
  final String? solverId;
  final CarryOverTaskSolver? solver;
  final String? solverNote;
  final String status;
  final String? updateBy;
  final String? updateDate;
  final String? location;
  final String? file;
  final String? evidenceUrl;

  const CarryOverTask({
    required this.id,
    required this.createBy,
    required this.createDate,
    required this.idShift,
    required this.reportDate,
    required this.reportId,
    required this.reportNote,
    this.solverDate,
    this.solverId,
    this.solver,
    this.solverNote,
    required this.status,
    this.updateBy,
    this.updateDate,
    this.location,
    this.file,
    this.evidenceUrl,
  });
}

class CarryOverTaskSolver {
  final String? id;
  final String? fullname;

  const CarryOverTaskSolver({
    this.id,
    this.fullname,
  });
}

class ShiftNowResult {
  final ShiftNowData? shiftNow;
  final Failure? failure;
  final bool isSuccess;

  const ShiftNowResult._({
    this.shiftNow,
    this.failure,
    required this.isSuccess,
  });

  factory ShiftNowResult.success(ShiftNowData shiftNow) {
    return ShiftNowResult._(
      shiftNow: shiftNow,
      isSuccess: true,
    );
  }

  factory ShiftNowResult.failure(Failure failure) {
    return ShiftNowResult._(
      failure: failure,
      isSuccess: false,
    );
  }
}

/// Entity for shift now data
class ShiftNowData {
  final String shiftDate;
  final String shiftName;
  final int totalPersonel;
  final int totalAttendance;
  final List<ShiftNowPersonnel> listPersonel;

  const ShiftNowData({
    required this.shiftDate,
    required this.shiftName,
    required this.totalPersonel,
    required this.totalAttendance,
    required this.listPersonel,
  });
}

class ShiftNowPersonnel {
  final String userId;
  final String fullname;
  final String? images;

  const ShiftNowPersonnel({
    required this.userId,
    required this.fullname,
    this.images,
  });
}
