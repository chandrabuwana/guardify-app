import 'package:json_annotation/json_annotation.dart';
import 'schedule_detail_response_model.dart';

part 'shift_now_response_model.g.dart';

/// Response model for Shift/get_shift_now API
@JsonSerializable()
class ShiftNowResponseModel {
  @JsonKey(name: 'Data')
  final ShiftNowDataModel? data;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Description')
  final String? description;

  ShiftNowResponseModel({
    this.data,
    required this.code,
    required this.succeeded,
    this.message,
    this.description,
  });

  factory ShiftNowResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftNowResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftNowResponseModelToJson(this);
}

/// Data model for shift now
@JsonSerializable()
class ShiftNowDataModel {
  @JsonKey(name: 'ShiftDate')
  final String shiftDate;

  @JsonKey(name: 'ShiftName')
  final String shiftName;

  @JsonKey(name: 'TotalPersonel')
  final int totalPersonel;

  @JsonKey(name: 'TotalAttendance')
  final int totalAttendance;

  @JsonKey(name: 'ListPersonel')
  final List<PersonnelModel> listPersonel;

  ShiftNowDataModel({
    required this.shiftDate,
    required this.shiftName,
    required this.totalPersonel,
    required this.totalAttendance,
    required this.listPersonel,
  });

  factory ShiftNowDataModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftNowDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftNowDataModelToJson(this);
}

