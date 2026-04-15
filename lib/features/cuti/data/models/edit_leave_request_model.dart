import 'package:json_annotation/json_annotation.dart';

part 'edit_leave_request_model.g.dart';

/// Request model untuk PUT /LeaveRequest/edit/{id}
@JsonSerializable()
class EditLeaveRequestModel {
  @JsonKey(name: 'ApproveBy')
  final String approveBy;

  @JsonKey(name: 'ApproveDate')
  final String approveDate;

  @JsonKey(name: 'CreateBy')
  final String createBy;

  @JsonKey(name: 'CreateDate')
  final String createDate;

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

  @JsonKey(name: 'Status')
  final String status;

  @JsonKey(name: 'UserId')
  final String userId;

  const EditLeaveRequestModel({
    required this.approveBy,
    required this.approveDate,
    required this.createBy,
    required this.createDate,
    required this.endDate,
    required this.idLeaveRequestType,
    required this.notes,
    required this.notesApproval,
    required this.startDate,
    required this.status,
    required this.userId,
  });

  factory EditLeaveRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EditLeaveRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$EditLeaveRequestModelToJson(this);

  /// Factory untuk create dari parameter sesuai dengan API spec
  factory EditLeaveRequestModel.create({
    required DateTime startDate,
    required DateTime endDate,
    required int idLeaveRequestType,
    required String notes,
    required String userId,
    required String createBy,
    required DateTime createDate,
    String approveBy = '-',
    DateTime? approveDate,
    String notesApproval = '',
    String status = 'WAITING_APPROVAL',
  }) {
    // Format StartDate dan EndDate: "YYYY-MM-DDTHH:mm:ss.SSS" (tanpa timezone)
    final startDateStr = _formatDateWithoutTimezone(startDate);
    final endDateStr = _formatDateWithoutTimezone(endDate);
    
    // Format CreateDate dan ApproveDate: "YYYY-MM-DDTHH:mm:ss.SSS" (tanpa timezone)
    final createDateStr = _formatDateWithoutTimezone(createDate);
    final approveDateStr = approveDate != null
        ? _formatDateWithoutTimezone(approveDate)
        : _formatDateWithoutTimezone(DateTime.now());

    return EditLeaveRequestModel(
      startDate: startDateStr,
      endDate: endDateStr,
      idLeaveRequestType: idLeaveRequestType,
      notes: notes,
      notesApproval: notesApproval,
      userId: userId,
      createBy: createBy,
      createDate: createDateStr,
      approveBy: approveBy,
      approveDate: approveDateStr,
      status: status,
    );
  }

  /// Helper method untuk format tanggal tanpa timezone
  /// Format: "YYYY-MM-DDTHH:mm:ss.SSS"
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
}
