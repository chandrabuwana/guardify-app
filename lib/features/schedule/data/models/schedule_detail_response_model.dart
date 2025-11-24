import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';
import 'shift_schedule_model.dart';

part 'schedule_detail_response_model.g.dart';

/// Response model for Shift/get_detail_schedule API
@JsonSerializable()
class ScheduleDetailResponseModel {
  @JsonKey(name: 'Data')
  final ScheduleDetailDataModel? data;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Description')
  final String? description;

  ScheduleDetailResponseModel({
    this.data,
    required this.code,
    required this.succeeded,
    this.message,
    this.description,
  });

  factory ScheduleDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDetailResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleDetailResponseModelToJson(this);
}

/// Data model for schedule detail
@JsonSerializable()
class ScheduleDetailDataModel {
  @JsonKey(name: 'ShiftName')
  final String shiftName;

  @JsonKey(name: 'StartTime')
  final String startTime;

  @JsonKey(name: 'EndTime')
  final String endTime;

  @JsonKey(name: 'Location')
  final String location;

  @JsonKey(name: 'RouteName')
  final String routeName;

  @JsonKey(name: 'ListPersonel')
  final List<PersonnelModel> listPersonel;

  @JsonKey(name: 'ListRoute')
  final List<dynamic> listRoute;

  ScheduleDetailDataModel({
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.routeName,
    required this.listPersonel,
    required this.listRoute,
  });

  factory ScheduleDetailDataModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDetailDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleDetailDataModelToJson(this);

  /// Convert to ShiftScheduleModel
  ShiftScheduleModel toShiftScheduleModel(DateTime date) {
    // Format shift time
    final shiftTime = '$startTime - $endTime';

    // Convert personnel to team members
    final teamMembers = listPersonel.map((personnel) {
      return TeamMemberModel(
        id: personnel.userId,
        name: personnel.fullname,
        position: location,
        photoUrl: (personnel.images != null && personnel.images!.isNotEmpty) ? personnel.images : null,
      );
    }).toList();

    return ShiftScheduleModel(
      id: '', // Not provided by API
      date: DateFormat('yyyy-MM-dd').format(date),
      shiftName: shiftName,
      shiftTime: shiftTime,
      location: location,
      position: location,
      route: routeName,
      patrolLocations: const [], // Not provided by API
      teamMembers: teamMembers,
    );
  }
}

/// Personnel model
@JsonSerializable()
class PersonnelModel {
  @JsonKey(name: 'UserId')
  final String userId;

  @JsonKey(name: 'Fullname')
  final String fullname;

  @JsonKey(name: 'Images')
  final String? images;

  PersonnelModel({
    required this.userId,
    required this.fullname,
    this.images,
  });

  factory PersonnelModel.fromJson(Map<String, dynamic> json) =>
      _$PersonnelModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonnelModelToJson(this);
}

