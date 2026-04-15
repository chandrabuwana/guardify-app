import '../../domain/entities/attendance_update_request.dart';

abstract class AttendanceRekapDetailEvent {}

class LoadAttendanceRekapDetailEvent extends AttendanceRekapDetailEvent {
  final String idAttendance;

  LoadAttendanceRekapDetailEvent(this.idAttendance);
}

class UpdateAttendanceRekapDetailEvent extends AttendanceRekapDetailEvent {
  final AttendanceUpdateRequest request;

  UpdateAttendanceRekapDetailEvent(this.request);
}

