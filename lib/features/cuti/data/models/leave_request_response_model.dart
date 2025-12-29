import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cuti_entity.dart';
import 'leave_request_type_model.dart' show LeaveRequestTypeModel;

part 'leave_request_response_model.g.dart';

/// Response model untuk API LeaveRequest/list
@JsonSerializable()
class LeaveRequestResponseModel {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<LeaveRequestItemModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  const LeaveRequestResponseModel({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory LeaveRequestResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveRequestResponseModelToJson(this);
}

/// Model untuk item leave request
@JsonSerializable()
class LeaveRequestItemModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final String? createDate;

  @JsonKey(name: 'EndDate')
  final String endDate;

  @JsonKey(name: 'Fullname')
  final String? fullname;

  @JsonKey(name: 'IdLeaveRequestType')
  final int idLeaveRequestType;

  @JsonKey(name: 'LeaveRequestType')
  final LeaveRequestTypeModel? leaveRequestType;

  @JsonKey(name: 'Nip')
  final String? nip;

  @JsonKey(name: 'Notes')
  final String? notes;

  @JsonKey(name: 'NotesApproval')
  final String? notesApproval;

  @JsonKey(name: 'StartDate')
  final String startDate;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final String? updateDate;

  @JsonKey(name: 'UserId')
  final String userId;

  @JsonKey(name: 'User')
  final UserLeaveModel? user;

  @JsonKey(name: 'Status')
  final String? status;

  @JsonKey(name: 'ApproveBy')
  final String? approveBy;

  @JsonKey(name: 'ApproveDate')
  final String? approveDate;

  const LeaveRequestItemModel({
    required this.id,
    this.createBy,
    this.createDate,
    required this.endDate,
    this.fullname,
    required this.idLeaveRequestType,
    this.leaveRequestType,
    this.nip,
    this.notes,
    this.notesApproval,
    required this.startDate,
    this.updateBy,
    this.updateDate,
    required this.userId,
    this.user,
    this.status,
    this.approveBy,
    this.approveDate,
  });

  factory LeaveRequestItemModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveRequestItemModelToJson(this);

  /// Convert to CutiEntity
  CutiEntity toEntity() {
    // Parse status dari field Status atau approval notes
    CutiStatus cutiStatus;
    if (status != null && status!.isNotEmpty) {
      // Parse status dari API response
      final statusLower = status!.toLowerCase();
      if (statusLower.contains('approved') || statusLower.contains('disetujui')) {
        cutiStatus = CutiStatus.approved;
      } else if (statusLower.contains('rejected') || statusLower.contains('ditolak')) {
        cutiStatus = CutiStatus.rejected;
      } else if (statusLower.contains('cancelled') || statusLower.contains('dibatalkan')) {
        cutiStatus = CutiStatus.cancelled;
      } else {
        cutiStatus = CutiStatus.pending;
      }
    } else if (notesApproval != null && notesApproval!.isNotEmpty) {
      // Fallback: Jika ada notes approval, berarti sudah direview
      cutiStatus = CutiStatus.approved;
    } else {
      cutiStatus = CutiStatus.pending;
    }

    // Parse tipe cuti dari LeaveRequestType
    CutiType tipeCuti;
    if (leaveRequestType?.name?.toLowerCase().contains('tahunan') ?? false) {
      tipeCuti = CutiType.tahunan;
    } else if (leaveRequestType?.name?.toLowerCase().contains('sakit') ??
        false) {
      tipeCuti = CutiType.sakit;
    } else if (leaveRequestType?.name?.toLowerCase().contains('melahirkan') ??
        false) {
      tipeCuti = CutiType.melahirkan;
    } else if (leaveRequestType?.name?.toLowerCase().contains('menikah') ??
        false) {
      tipeCuti = CutiType.menikah;
    } else if (leaveRequestType?.name?.toLowerCase().contains('meninggal') ??
        false) {
      tipeCuti = CutiType.keluargaMeninggal;
    } else {
      tipeCuti = CutiType.lainnya;
    }

    // Parse tanggal
    DateTime tanggalMulai;
    DateTime tanggalSelesai;
    DateTime tanggalPengajuan;

    try {
      tanggalMulai = DateTime.parse(startDate);
    } catch (e) {
      tanggalMulai = DateTime.now();
    }

    try {
      tanggalSelesai = DateTime.parse(endDate);
    } catch (e) {
      tanggalSelesai = DateTime.now();
    }

    try {
      tanggalPengajuan = createDate != null
          ? DateTime.parse(createDate!)
          : DateTime.now();
    } catch (e) {
      tanggalPengajuan = DateTime.now();
    }

    // Hitung jumlah hari
    int jumlahHari = tanggalSelesai.difference(tanggalMulai).inDays + 1;

    // Get nama dari user atau fullname
    String nama = user?.fullname ?? fullname ?? 'Unknown';

    // Parse tanggal review dari ApproveDate atau UpdateDate
    DateTime? tanggalReview;
    try {
      if (approveDate != null && approveDate!.isNotEmpty) {
        tanggalReview = DateTime.parse(approveDate!);
      } else if (updateDate != null && updateDate!.isNotEmpty) {
        tanggalReview = DateTime.parse(updateDate!);
      }
    } catch (e) {
      tanggalReview = null;
    }

    return CutiEntity(
      id: id,
      nama: nama,
      userId: userId,
      tipeCuti: tipeCuti,
      tanggalMulai: tanggalMulai,
      tanggalSelesai: tanggalSelesai,
      alasan: notes ?? '',
      status: cutiStatus,
      umpanBalik: notesApproval,
      reviewerId: approveBy ?? updateBy,
      reviewerName: null, // Not available in API response
      tanggalPengajuan: tanggalPengajuan,
      tanggalReview: tanggalReview,
      jumlahHari: jumlahHari,
    );
  }
}

/// Model untuk user dalam leave request
@JsonSerializable()
class UserLeaveModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Username')
  final String? username;

  @JsonKey(name: 'Fullname')
  final String? fullname;

  @JsonKey(name: 'Email')
  final String? email;

  @JsonKey(name: 'PhoneNumber')
  final String? phoneNumber;

  @JsonKey(name: 'Status')
  final String? status;

  const UserLeaveModel({
    required this.id,
    this.username,
    this.fullname,
    this.email,
    this.phoneNumber,
    this.status,
  });

  factory UserLeaveModel.fromJson(Map<String, dynamic> json) =>
      _$UserLeaveModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserLeaveModelToJson(this);
}
