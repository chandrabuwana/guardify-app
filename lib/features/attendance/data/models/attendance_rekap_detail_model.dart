import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/attendance_rekap_detail_entity.dart';
import '../../domain/entities/attendance_rekap_detail_response_entity.dart';

part 'attendance_rekap_detail_model.g.dart';

/// Response model untuk API Attendance/get_detail_rekap
@JsonSerializable()
class AttendanceRekapDetailResponseModel {
  @JsonKey(name: 'Data')
  final AttendanceRekapDetailDataModel? data;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  const AttendanceRekapDetailResponseModel({
    this.data,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory AttendanceRekapDetailResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$AttendanceRekapDetailResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AttendanceRekapDetailResponseModelToJson(this);

  AttendanceRekapDetailResponseEntity toEntity() {
    return AttendanceRekapDetailResponseEntity(
      data: data?.toEntity(),
      code: code,
      succeeded: succeeded,
      message: message,
      description: description,
    );
  }
}

/// Model untuk data detail
@JsonSerializable()
class AttendanceRekapDetailDataModel {
  @JsonKey(name: 'IdAttendance')
  final String idAttendance;

  @JsonKey(name: 'IdShift')
  final String idShift;

  @JsonKey(name: 'Fullname')
  final String fullname;

  @JsonKey(name: 'Nrp')
  final String nrp;

  @JsonKey(name: 'Jabatan')
  final String jabatan;

  @JsonKey(name: 'PhotoPegawai')
  final String? photoPegawai;

  @JsonKey(name: 'StatusLaporan')
  final String statusLaporan;

  @JsonKey(name: 'ShiftDate')
  final String shiftDate;

  @JsonKey(name: 'ShiftName')
  final String shiftName;

  @JsonKey(name: 'Location')
  final String? location;

  @JsonKey(name: 'Route')
  final String? route;

  @JsonKey(name: 'Patrol')
  final String? patrol;

  @JsonKey(name: 'CheckIn')
  final String? checkIn;

  @JsonKey(name: 'PhotoPakaian')
  final PhotoInfoModel? photoPakaian;

  @JsonKey(name: 'Notes')
  final String? notes;

  @JsonKey(name: 'NotesCheckout')
  final String? notesCheckout;

  @JsonKey(name: 'PhotoPengamanan')
  final PhotoInfoModel? photoPengamanan;

  @JsonKey(name: 'ListCarryOver')
  final List<CarryOverItemModel> listCarryOver;

  @JsonKey(name: 'PhotoCheckin')
  final PhotoInfoModel? photoCheckin;

  @JsonKey(name: 'ListRoute')
  final List<RouteItemModel> listRoute;

  @JsonKey(name: 'CheckOut')
  final String? checkOut;

  @JsonKey(name: 'CarryOver')
  final String? carryOver;

  @JsonKey(name: 'IsOvertime')
  final bool isOvertime;

  @JsonKey(name: 'StatusKerja')
  final String? statusKerja;

  @JsonKey(name: 'PhotoCheckout')
  final PhotoInfoModel? photoCheckout;

  @JsonKey(name: 'PhotoCheckoutPengamanan')
  final PhotoInfoModel? photoCheckoutPengamanan;

  @JsonKey(name: 'PhotoCheckoutPakaian')
  final PhotoInfoModel? photoCheckoutPakaian;

  @JsonKey(name: 'PhotoOvertime')
  final PhotoInfoModel? photoOvertime;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final String? updateDate;
  @JsonKey(name: 'Feedback')
  final String? feedback;

  const AttendanceRekapDetailDataModel({
    required this.idAttendance,
    required this.idShift,
    required this.fullname,
    required this.nrp,
    required this.jabatan,
    this.photoPegawai,
    required this.statusLaporan,
    required this.shiftDate,
    required this.shiftName,
    this.location,
    this.route,
    this.patrol,
    this.checkIn,
    this.photoPakaian,
    this.notes,
    this.notesCheckout,
    this.photoPengamanan,
    required this.listCarryOver,
    this.photoCheckin,
    required this.listRoute,
    this.checkOut,
    this.carryOver,
    required this.isOvertime,
    this.statusKerja,
    this.photoCheckout,
    this.photoCheckoutPengamanan,
    this.photoCheckoutPakaian,
    this.photoOvertime,
    this.updateBy,
    this.updateDate,
    this.feedback,
  });

  factory AttendanceRekapDetailDataModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRekapDetailDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceRekapDetailDataModelToJson(this);

  AttendanceRekapDetailEntity toEntity() {
    DateTime? parsedCheckIn;
    DateTime? parsedCheckOut;
    DateTime? parsedUpdateDate;

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

    try {
      if (updateDate != null) {
        parsedUpdateDate = DateTime.parse(updateDate!);
      }
    } catch (e) {
      parsedUpdateDate = null;
    }

    return AttendanceRekapDetailEntity(
      idAttendance: idAttendance,
      idShift: idShift,
      fullname: fullname,
      nrp: nrp,
      jabatan: jabatan,
      photoPegawai: photoPegawai,
      statusLaporan: statusLaporan,
      shiftDate: DateTime.parse(shiftDate),
      shiftName: shiftName,
      location: location,
      route: route,
      patrol: patrol,
      checkIn: parsedCheckIn,
      photoPakaian: photoPakaian?.toEntity(),
      notes: notes,
      notesCheckout: notesCheckout,
      photoPengamanan: photoPengamanan?.toEntity(),
      listCarryOver: listCarryOver.map((e) => e.toEntity()).toList(),
      photoCheckin: photoCheckin?.toEntity(),
      listRoute: listRoute.map((e) => e.toEntity()).toList(),
      checkOut: parsedCheckOut,
      carryOver: carryOver,
      isOvertime: isOvertime,
      statusKerja: statusKerja,
      photoCheckout: photoCheckout?.toEntity(),
      photoCheckoutPengamanan: photoCheckoutPengamanan?.toEntity(),
      photoCheckoutPakaian: photoCheckoutPakaian?.toEntity(),
      photoOvertime: photoOvertime?.toEntity(),
      updateBy: updateBy,
      updateDate: parsedUpdateDate,
      feedback: feedback,
    );
  }
}

/// Model untuk photo info
@JsonSerializable()
class PhotoInfoModel {
  @JsonKey(name: 'Filename')
  final String? filename;

  @JsonKey(name: 'Url')
  final String? url;

  const PhotoInfoModel({
    this.filename,
    this.url,
  });

  factory PhotoInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoInfoModelToJson(this);

  PhotoInfo toEntity() {
    return PhotoInfo(
      filename: filename,
      url: url,
    );
  }
}

/// Model untuk carry over item
@JsonSerializable()
class CarryOverItemModel {
  @JsonKey(name: 'Note')
  final String note;

  @JsonKey(name: 'Status')
  final String status;

  const CarryOverItemModel({
    required this.note,
    required this.status,
  });

  factory CarryOverItemModel.fromJson(Map<String, dynamic> json) =>
      _$CarryOverItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarryOverItemModelToJson(this);

  CarryOverItem toEntity() {
    return CarryOverItem(
      note: note,
      status: status,
    );
  }
}

/// Model untuk route item
@JsonSerializable()
class RouteItemModel {
  @JsonKey(name: 'AreasName')
  final String areasName;

  @JsonKey(name: 'CheckDate')
  final String? checkDate;

  @JsonKey(name: 'PhotoRoute')
  final PhotoInfoModel? photoRoute;

  const RouteItemModel({
    required this.areasName,
    this.checkDate,
    this.photoRoute,
  });

  factory RouteItemModel.fromJson(Map<String, dynamic> json) =>
      _$RouteItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteItemModelToJson(this);

  RouteItem toEntity() {
    return RouteItem(
      areasName: areasName,
      checkDate: checkDate != null ? DateTime.tryParse(checkDate!) : null,
      photoRoute: photoRoute?.toEntity(),
    );
  }
}

