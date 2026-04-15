import '../../domain/entities/attendance_rekap_request_entity.dart';

abstract class AttendanceRekapEvent {}

class LoadAttendanceRekapEvent extends AttendanceRekapEvent {
  final AttendanceRekapRequestEntity request;

  LoadAttendanceRekapEvent(this.request);
}

class SearchAttendanceRekapEvent extends AttendanceRekapEvent {
  final String query;

  SearchAttendanceRekapEvent(this.query);
}

class FilterAttendanceRekapEvent extends AttendanceRekapEvent {
  final String status;

  FilterAttendanceRekapEvent(this.status);
}

class ClearSearchAttendanceRekapEvent extends AttendanceRekapEvent {}

class RefreshAttendanceRekapEvent extends AttendanceRekapEvent {
  final AttendanceRekapRequestEntity request;

  RefreshAttendanceRekapEvent(this.request);
}

