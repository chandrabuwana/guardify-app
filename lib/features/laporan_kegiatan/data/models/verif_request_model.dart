import 'package:json_annotation/json_annotation.dart';

part 'verif_request_model.g.dart';

/// Request model untuk API Attendance/verif
@JsonSerializable()
class VerifRequestModel {
  @JsonKey(name: 'IdAttendance')
  final String idAttendance;

  @JsonKey(name: 'IsVerif')
  final bool isVerif;

  @JsonKey(name: 'Feedback')
  final String? feedback;

  VerifRequestModel({
    required this.idAttendance,
    required this.isVerif,
    this.feedback,
  });

  factory VerifRequestModel.fromJson(Map<String, dynamic> json) =>
      _$VerifRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifRequestModelToJson(this);
}

/// Response model untuk API Attendance/verif
@JsonSerializable()
class VerifResponseModel {
  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  VerifResponseModel({
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory VerifResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifResponseModelToJson(this);
}

