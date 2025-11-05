import 'package:json_annotation/json_annotation.dart';

part 'create_leave_request_model.g.dart';

/// Request model untuk POST /LeaveRequest/add
@JsonSerializable()
class CreateLeaveRequestModel {
  @JsonKey(name: 'EndDate')
  final String endDate;

  @JsonKey(name: 'Fullname')
  final String fullname;

  @JsonKey(name: 'IdLeaveRequestType')
  final int idLeaveRequestType;

  @JsonKey(name: 'Nip')
  final String nip;

  @JsonKey(name: 'Notes')
  final String notes;

  @JsonKey(name: 'NotesApproval')
  final String? notesApproval;

  @JsonKey(name: 'StartDate')
  final String startDate;

  @JsonKey(name: 'UserId')
  final String userId;

  const CreateLeaveRequestModel({
    required this.endDate,
    required this.fullname,
    required this.idLeaveRequestType,
    required this.nip,
    required this.notes,
    this.notesApproval,
    required this.startDate,
    required this.userId,
  });

  factory CreateLeaveRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateLeaveRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateLeaveRequestModelToJson(this);

  /// Factory untuk create dari parameter
  factory CreateLeaveRequestModel.create({
    required DateTime startDate,
    required DateTime endDate,
    required String fullname,
    required int idLeaveRequestType,
    required String nip,
    required String notes,
    String? notesApproval,
    required String userId,
  }) {
    return CreateLeaveRequestModel(
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
      fullname: fullname,
      idLeaveRequestType: idLeaveRequestType,
      nip: nip,
      notes: notes,
      notesApproval: notesApproval,
      userId: userId,
    );
  }
}

/// Response model untuk POST /LeaveRequest/add
@JsonSerializable()
class CreateLeaveRequestResponseModel {
  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  const CreateLeaveRequestResponseModel({
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory CreateLeaveRequestResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreateLeaveRequestResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CreateLeaveRequestResponseModelToJson(this);
}
