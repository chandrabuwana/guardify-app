import 'package:equatable/equatable.dart';
import 'attendance.dart';

enum UserRole { member, danton, deputy, pjo, supervisor }

class AttendanceValidationRules extends Equatable {
  final ShiftType shiftType;
  final DateTime morningCutoffTime;
  final DateTime nightCutoffTime;
  final bool requireLocationMatch;
  final bool requireAllFields;
  final List<UserRole> allowedRoles;

  const AttendanceValidationRules({
    required this.shiftType,
    required this.morningCutoffTime,
    required this.nightCutoffTime,
    this.requireLocationMatch = true,
    this.requireAllFields = true,
    this.allowedRoles = const [UserRole.member],
  });

  bool isTimeValid(DateTime attendanceTime) {
    if (shiftType == ShiftType.morning) {
      return attendanceTime.isBefore(morningCutoffTime) ||
          attendanceTime.isAtSameMomentAs(morningCutoffTime);
    } else {
      return attendanceTime.isBefore(nightCutoffTime) ||
          attendanceTime.isAtSameMomentAs(nightCutoffTime);
    }
  }

  bool isUserAuthorized(UserRole userRole) {
    // PJO and Deputy have access to ALL
    if (userRole == UserRole.pjo || userRole == UserRole.deputy) {
      return true;
    }
    return allowedRoles.contains(userRole);
  }

  @override
  List<Object?> get props => [
        shiftType,
        morningCutoffTime,
        nightCutoffTime,
        requireLocationMatch,
        requireAllFields,
        allowedRoles,
      ];
}
