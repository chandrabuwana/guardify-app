import 'attendance_rekap_entity.dart';

/// Entity untuk response rekapitulasi kehadiran
class AttendanceRekapResponseEntity {
  final int count;
  final int filtered;
  final List<AttendanceRekapEntity> list;
  final int code;
  final bool succeeded;
  final String message;
  final String? description;

  const AttendanceRekapResponseEntity({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });
}

