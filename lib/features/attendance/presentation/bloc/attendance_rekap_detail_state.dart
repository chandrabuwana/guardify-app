import '../../domain/entities/attendance_rekap_detail_entity.dart';

abstract class AttendanceRekapDetailState {
  const AttendanceRekapDetailState();
}

class AttendanceRekapDetailInitial extends AttendanceRekapDetailState {
  const AttendanceRekapDetailInitial();
}

class AttendanceRekapDetailLoading extends AttendanceRekapDetailState {
  const AttendanceRekapDetailLoading();
}

class AttendanceRekapDetailLoaded extends AttendanceRekapDetailState {
  final AttendanceRekapDetailEntity detail;

  const AttendanceRekapDetailLoaded({required this.detail});
}

class AttendanceRekapDetailFailure extends AttendanceRekapDetailState {
  final String message;

  const AttendanceRekapDetailFailure(this.message);
}

class AttendanceRekapDetailUpdating extends AttendanceRekapDetailState {
  const AttendanceRekapDetailUpdating();
}

class AttendanceRekapDetailUpdateSuccess extends AttendanceRekapDetailState {
  const AttendanceRekapDetailUpdateSuccess();
}

