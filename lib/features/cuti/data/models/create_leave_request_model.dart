import 'package:json_annotation/json_annotation.dart';

part 'create_leave_request_model.g.dart';

/// Request model untuk POST /LeaveRequest/add
@JsonSerializable()
class CreateLeaveRequestModel {
  @JsonKey(name: 'ApproveDate')
  final String? approveDate;

  @JsonKey(name: 'EndDate')
  final String endDate;

  @JsonKey(name: 'IdLeaveRequestType')
  final int idLeaveRequestType;

  @JsonKey(name: 'Notes')
  final String notes;

  @JsonKey(name: 'NotesApproval')
  final String notesApproval;

  @JsonKey(name: 'StartDate')
  final String startDate;

  @JsonKey(name: 'UserId')
  final String userId;

  @JsonKey(name: 'Status')
  final String status;

  @JsonKey(name: 'ApproveBy')
  final String approveBy;

  const CreateLeaveRequestModel({
    this.approveDate,
    required this.endDate,
    required this.idLeaveRequestType,
    required this.notes,
    required this.notesApproval,
    required this.startDate,
    required this.userId,
    required this.status,
    required this.approveBy,
  });

  factory CreateLeaveRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateLeaveRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateLeaveRequestModelToJson(this);

  /// Factory untuk create dari parameter sesuai dengan API spec
  factory CreateLeaveRequestModel.create({
    required DateTime startDate,
    required DateTime endDate,
    required int idLeaveRequestType,
    required String notes,
    required String userId,
    DateTime? approveDate,
    String notesApproval = '-',
    String status = '-',
    String approveBy = '-',
  }) {
    // Format StartDate dan EndDate: "YYYY-MM-DDTHH:mm:ss.SSS" (tanpa timezone)
    // Contoh: "2025-12-04T00:00:00.000"
    final startDateStr = _formatDateWithoutTimezone(startDate);
    final endDateStr = _formatDateWithoutTimezone(endDate);
    
    // Format ApproveDate: "YYYY-MM-DDTHH:mm:ss.SSSZ" (dengan timezone UTC)
    // Contoh: "2025-12-04T15:01:15.283Z"
    final approveDateStr = approveDate != null
        ? _formatDateWithTimezone(approveDate.toUtc())
        : null;

    return CreateLeaveRequestModel(
      startDate: startDateStr,
      endDate: endDateStr,
      idLeaveRequestType: idLeaveRequestType,
      notes: notes,
      notesApproval: notesApproval,
      userId: userId,
      approveDate: approveDateStr,
      status: status,
      approveBy: approveBy,
    );
  }

  /// Helper method untuk format tanggal tanpa timezone
  /// Format: "YYYY-MM-DDTHH:mm:ss.SSS"
  /// Contoh: "2025-12-04T00:00:00.000"
  static String _formatDateWithoutTimezone(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');
    final millisecond = date.millisecond.toString().padLeft(3, '0');
    
    return '$year-$month-${day}T$hour:$minute:$second.$millisecond';
  }

  /// Helper method untuk format tanggal dengan timezone UTC
  /// Format: "YYYY-MM-DDTHH:mm:ss.SSSZ"
  /// Contoh: "2025-12-04T15:01:15.283Z"
  static String _formatDateWithTimezone(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');
    final millisecond = date.millisecond.toString().padLeft(3, '0');
    
    return '$year-$month-${day}T$hour:$minute:$second.${millisecond}Z';
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
