import 'package:json_annotation/json_annotation.dart';
import 'schedule_detail_response_model.dart';

part 'current_shift_response_model.g.dart';

/// Response model for Shift/get_current API
@JsonSerializable()
class CurrentShiftResponseModel {
  @JsonKey(name: 'Data')
  final CurrentShiftDataModel? data;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Description')
  final String? description;

  CurrentShiftResponseModel({
    this.data,
    required this.code,
    required this.succeeded,
    this.message,
    this.description,
  });

  factory CurrentShiftResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentShiftResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentShiftResponseModelToJson(this);
}

/// Data model for current shift
@JsonSerializable()
class CurrentShiftDataModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'StartTime')
  final String startTime;

  @JsonKey(name: 'Checkin')
  final bool checkin;

  @JsonKey(name: 'Checkout')
  final bool checkout;

  @JsonKey(name: 'CheckinTime')
  final String? checkinTime;

  @JsonKey(name: 'CheckoutTime')
  final String? checkoutTime;

  @JsonKey(name: 'ListPersonel')
  final List<PersonnelModel> listPersonel;

  @JsonKey(name: 'IdShiftDetail')
  final String? idShiftDetail;

  @JsonKey(name: 'ShiftDate')
  final String? shiftDate;

  @JsonKey(name: 'Location')
  final String? location;

  @JsonKey(name: 'IsOnLeave')
  final bool isOnLeave;

  CurrentShiftDataModel({
    required this.id,
    required this.name,
    required this.startTime,
    required this.checkin,
    required this.checkout,
    this.checkinTime,
    this.checkoutTime,
    required this.listPersonel,
    this.idShiftDetail,
    this.shiftDate,
    this.location,
    this.isOnLeave = false,
  });

  factory CurrentShiftDataModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentShiftDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentShiftDataModelToJson(this);
}


