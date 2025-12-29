import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/attendance_rekap_entity.dart';
import '../../domain/entities/attendance_rekap_response_entity.dart';

part 'attendance_rekap_model.g.dart';

/// Response model untuk API Attendance/get_rekap
@JsonSerializable()
class AttendanceRekapResponseModel {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<AttendanceRekapItemModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  const AttendanceRekapResponseModel({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory AttendanceRekapResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRekapResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceRekapResponseModelToJson(this);

  AttendanceRekapResponseEntity toEntity() {
    return AttendanceRekapResponseEntity(
      count: count,
      filtered: filtered,
      list: list.map((item) => item.toEntity()).toList(),
      code: code,
      succeeded: succeeded,
      message: message,
      description: description,
    );
  }
}

/// Model untuk item rekapitulasi kehadiran
@JsonSerializable()
class AttendanceRekapItemModel {
  @JsonKey(name: 'IdAttendance')
  final String? idAttendance;

  @JsonKey(name: 'ShiftDate')
  final String shiftDate;

  @JsonKey(name: 'ShiftName')
  final String shiftName;

  @JsonKey(name: 'IsOvertime')
  final bool isOvertime;

  @JsonKey(name: 'Status')
  final String? status;

  @JsonKey(name: 'StatusAttendance')
  final String statusAttendance;

  @JsonKey(name: 'StatusCarryOver')
  final String statusCarryOver;

  @JsonKey(name: 'Patrol')
  final String patrol;

  @JsonKey(name: 'CheckIn')
  final String? checkIn;

  @JsonKey(name: 'CheckOut')
  final String? checkOut;

  const AttendanceRekapItemModel({
    this.idAttendance,
    required this.shiftDate,
    required this.shiftName,
    required this.isOvertime,
    this.status,
    required this.statusAttendance,
    required this.statusCarryOver,
    required this.patrol,
    this.checkIn,
    this.checkOut,
  });

  factory AttendanceRekapItemModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRekapItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceRekapItemModelToJson(this);

  AttendanceRekapEntity toEntity() {
    DateTime? parsedCheckIn;
    DateTime? parsedCheckOut;

    try {
      if (checkIn != null) {
        parsedCheckIn = DateTime.parse(checkIn!);
      }
    } catch (e) {
      parsedCheckIn = null;
    }

    try {
      if (checkOut != null) {
        parsedCheckOut = DateTime.parse(checkOut!);
      }
    } catch (e) {
      parsedCheckOut = null;
    }

    return AttendanceRekapEntity(
      idAttendance: idAttendance,
      shiftDate: DateTime.parse(shiftDate),
      shiftName: shiftName,
      isOvertime: isOvertime,
      status: status,
      statusAttendance: statusAttendance,
      statusCarryOver: statusCarryOver,
      patrol: patrol,
      checkIn: parsedCheckIn,
      checkOut: parsedCheckOut,
    );
  }
}

