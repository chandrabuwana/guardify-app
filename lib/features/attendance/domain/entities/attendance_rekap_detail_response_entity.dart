import 'attendance_rekap_detail_entity.dart';

/// Entity untuk response detail rekapitulasi kehadiran
class AttendanceRekapDetailResponseEntity {
  final AttendanceRekapDetailEntity? data;
  final int code;
  final bool succeeded;
  final String message;
  final String? description;

  const AttendanceRekapDetailResponseEntity({
    this.data,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });
}

