import 'package:json_annotation/json_annotation.dart';
import 'schedule_detail_response_model.dart';

part 'schedule_pengawas_response_model.g.dart';

/// Response model for Shift/get_schedule_pengawas API
@JsonSerializable()
class SchedulePengawasResponseModel {
  @JsonKey(name: 'Data')
  final SchedulePengawasDataModel? data;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Description')
  final String? description;

  SchedulePengawasResponseModel({
    this.data,
    required this.code,
    required this.succeeded,
    this.message,
    this.description,
  });

  factory SchedulePengawasResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SchedulePengawasResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SchedulePengawasResponseModelToJson(this);
}

/// Data model for pengawas schedule
@JsonSerializable()
class SchedulePengawasDataModel {
  @JsonKey(name: 'ShiftDate')
  final String shiftDate;

  @JsonKey(name: 'ListShift')
  final List<ShiftPengawasModel> listShift;

  SchedulePengawasDataModel({
    required this.shiftDate,
    required this.listShift,
  });

  factory SchedulePengawasDataModel.fromJson(Map<String, dynamic> json) =>
      _$SchedulePengawasDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SchedulePengawasDataModelToJson(this);
}

/// Shift model for pengawas schedule
@JsonSerializable()
class ShiftPengawasModel {
  @JsonKey(name: 'StartTime')
  final String startTime;

  @JsonKey(name: 'EndTime')
  final String endTime;

  @JsonKey(name: 'ShiftName')
  final String shiftName;

  @JsonKey(name: 'TotalPersonel')
  final int totalPersonel;

  @JsonKey(name: 'ListRoute')
  final List<RoutePengawasModel> listRoute;

  ShiftPengawasModel({
    required this.startTime,
    required this.endTime,
    required this.shiftName,
    required this.totalPersonel,
    required this.listRoute,
  });

  factory ShiftPengawasModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftPengawasModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftPengawasModelToJson(this);
}

/// Route model for pengawas schedule
@JsonSerializable()
class RoutePengawasModel {
  @JsonKey(name: 'AreasName')
  final String areasName;

  @JsonKey(name: 'ListPersonel')
  final List<PersonnelModel> listPersonel;

  RoutePengawasModel({
    required this.areasName,
    required this.listPersonel,
  });

  factory RoutePengawasModel.fromJson(Map<String, dynamic> json) =>
      _$RoutePengawasModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoutePengawasModelToJson(this);
}

