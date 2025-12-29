import '../../domain/entities/incident_entity.dart';
import 'incident_model.dart';

class IncidentApiModel {
  final String id;
  final String? areasDescription;
  final String? areasId;
  final AreasModel? areas;
  final String? createBy;
  final DateTime? createDate;
  final int? idIncidentType;
  final IncidentTypeApiModel? incidentType;
  final DateTime? incidentDate;
  final String? incidentTime;
  final String? incidentDescription;
  final String? notesAction;
  final String? picId;
  final UserModel? pic;
  final String? pjId;
  final UserModel? pj;
  final String? reportId;
  final UserModel? report;
  final String? solvedAction;
  final DateTime? solvedDate;
  final String? status;
  final String? updateBy;
  final DateTime? updateDate;
  final List<dynamic>? incidentDetail;

  const IncidentApiModel({
    required this.id,
    this.areasDescription,
    this.areasId,
    this.areas,
    this.createBy,
    this.createDate,
    this.idIncidentType,
    this.incidentType,
    this.incidentDate,
    this.incidentTime,
    this.incidentDescription,
    this.notesAction,
    this.picId,
    this.pic,
    this.pjId,
    this.pj,
    this.reportId,
    this.report,
    this.solvedAction,
    this.solvedDate,
    this.status,
    this.updateBy,
    this.updateDate,
    this.incidentDetail,
  });

  factory IncidentApiModel.fromJson(Map<String, dynamic> json) {
    return IncidentApiModel(
      id: json['Id']?.toString() ?? '',
      areasDescription: json['AreasDescription']?.toString(),
      areasId: json['AreasId']?.toString(),
      areas: json['Areas'] != null
          ? AreasModel.fromJson(json['Areas'] as Map<String, dynamic>)
          : null,
      createBy: json['CreateBy']?.toString(),
      createDate: json['CreateDate'] != null
          ? DateTime.tryParse(json['CreateDate'].toString())
          : null,
      idIncidentType: json['IdIncidentType'] as int?,
      incidentType: json['IncidentType'] != null
          ? IncidentTypeApiModel.fromJson(json['IncidentType'] as Map<String, dynamic>)
          : null,
      incidentDate: json['IncidentDate'] != null
          ? DateTime.tryParse(json['IncidentDate'].toString())
          : null,
      incidentTime: json['IncidentTime']?.toString(),
      incidentDescription: json['IncidentDescription']?.toString(),
      notesAction: json['NotesAction']?.toString(),
      picId: json['PicId']?.toString(),
      pic: json['Pic'] != null
          ? UserModel.fromJson(json['Pic'] as Map<String, dynamic>)
          : null,
      pjId: json['PjId']?.toString(),
      pj: json['Pj'] != null
          ? UserModel.fromJson(json['Pj'] as Map<String, dynamic>)
          : null,
      reportId: json['ReportId']?.toString(),
      report: json['Report'] != null
          ? UserModel.fromJson(json['Report'] as Map<String, dynamic>)
          : null,
      solvedAction: json['SolvedAction']?.toString(),
      solvedDate: json['SolvedDate'] != null
          ? DateTime.tryParse(json['SolvedDate'].toString())
          : null,
      status: json['Status']?.toString(),
      updateBy: json['UpdateBy']?.toString(),
      updateDate: json['UpdateDate'] != null
          ? DateTime.tryParse(json['UpdateDate'].toString())
          : null,
      incidentDetail: json['IncidentDetail'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'AreasDescription': areasDescription,
      'AreasId': areasId,
      'Areas': areas?.toJson(),
      'CreateBy': createBy,
      'CreateDate': createDate?.toIso8601String(),
      'IdIncidentType': idIncidentType,
      'IncidentType': incidentType?.toJson(),
      'IncidentDate': incidentDate?.toIso8601String(),
      'IncidentTime': incidentTime,
      'IncidentDescription': incidentDescription,
      'NotesAction': notesAction,
      'PicId': picId,
      'Pic': pic?.toJson(),
      'PjId': pjId,
      'Pj': pj?.toJson(),
      'ReportId': reportId,
      'Report': report?.toJson(),
      'SolvedAction': solvedAction,
      'SolvedDate': solvedDate?.toIso8601String(),
      'Status': status,
      'UpdateBy': updateBy,
      'UpdateDate': updateDate?.toIso8601String(),
      'IncidentDetail': incidentDetail,
    };
  }

  IncidentModel toIncidentModel() {
    // Parse status
    IncidentStatus incidentStatus = IncidentStatus.menunggu;
    if (status != null && status!.isNotEmpty) {
      final statusUpper = status!.toUpperCase().trim();
      switch (statusUpper) {
        case 'OPEN':
          incidentStatus = IncidentStatus.menunggu;
          break;
        case 'INVALID':
          incidentStatus = IncidentStatus.tidakValid;
          break;
        case 'ACKNOWLEDGE':
          incidentStatus = IncidentStatus.diterima;
          break;
        case 'ESCALATED':
          incidentStatus = IncidentStatus.eskalasi;
          break;
        case 'ASSIGNED':
          incidentStatus = IncidentStatus.ditugaskan;
          break;
        case 'PROGRESS':
          incidentStatus = IncidentStatus.proses;
          break;
        case 'COMPLETED':
          incidentStatus = IncidentStatus.selesai;
          break;
        case 'VERIFIED':
          incidentStatus = IncidentStatus.terverifikasi;
          break;
        default:
          incidentStatus = IncidentStatus.menunggu;
      }
    }

    // Parse incident type
    IncidentType? incidentTypeEnum;
    if (incidentType != null && incidentType!.name != null) {
      switch (incidentType!.name!.toLowerCase()) {
        case 'keamanan':
          incidentTypeEnum = IncidentType.keamanan;
          break;
        case 'kebakaran':
          incidentTypeEnum = IncidentType.kebakaran;
          break;
        case 'medis':
          incidentTypeEnum = IncidentType.medis;
          break;
        default:
          incidentTypeEnum = IncidentType.lainnya;
      }
    }

    // Combine date and time
    DateTime? combinedDateTime;
    if (incidentDate != null && incidentTime != null) {
      try {
        final timeParts = incidentTime!.split(':');
        if (timeParts.length >= 2) {
          combinedDateTime = DateTime(
            incidentDate!.year,
            incidentDate!.month,
            incidentDate!.day,
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
          );
        }
      } catch (e) {
        combinedDateTime = incidentDate;
      }
    }

    return IncidentModel(
      id: id,
      status: incidentStatus,
      pelapor: report?.fullname,
      pelaporId: reportId,
      namaDanton: pj?.fullname,
      tanggalInsiden: incidentDate,
      jamInsiden: combinedDateTime ?? incidentDate,
      lokasiInsiden: areas?.name ?? areasDescription,
      detailLokasiInsiden: areasDescription,
      tipeInsiden: incidentTypeEnum,
      deskripsiInsiden: incidentDescription ?? '',
      pic: pic?.fullname,
      picId: picId,
      createDate: createDate,
      createBy: createBy,
    );
  }
}

class AreasModel {
  final String id;
  final bool? active;
  final String? createBy;
  final DateTime? createDate;
  final int? idSite;
  final double? latitude;
  final double? longitude;
  final String? name;
  final double? radius;
  final String? typeArea;
  final String? updateBy;
  final DateTime? updateDate;

  const AreasModel({
    required this.id,
    this.active,
    this.createBy,
    this.createDate,
    this.idSite,
    this.latitude,
    this.longitude,
    this.name,
    this.radius,
    this.typeArea,
    this.updateBy,
    this.updateDate,
  });

  factory AreasModel.fromJson(Map<String, dynamic> json) {
    return AreasModel(
      id: json['Id']?.toString() ?? '',
      active: json['Active'] as bool?,
      createBy: json['CreateBy']?.toString(),
      createDate: json['CreateDate'] != null
          ? DateTime.parse(json['CreateDate'])
          : null,
      idSite: json['IdSite'] as int?,
      latitude: (json['Latitude'] as num?)?.toDouble(),
      longitude: (json['Longitude'] as num?)?.toDouble(),
      name: json['Name']?.toString(),
      radius: (json['Radius'] as num?)?.toDouble(),
      typeArea: json['TypeArea']?.toString(),
      updateBy: json['UpdateBy']?.toString(),
      updateDate: json['UpdateDate'] != null
          ? DateTime.parse(json['UpdateDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Active': active,
      'CreateBy': createBy,
      'CreateDate': createDate?.toIso8601String(),
      'IdSite': idSite,
      'Latitude': latitude,
      'Longitude': longitude,
      'Name': name,
      'Radius': radius,
      'TypeArea': typeArea,
      'UpdateBy': updateBy,
      'UpdateDate': updateDate?.toIso8601String(),
    };
  }
}

class IncidentTypeApiModel {
  final int id;
  final bool? active;
  final String? createBy;
  final DateTime? createDate;
  final String? description;
  final String? name;
  final String? updateBy;
  final DateTime? updateDate;

  const IncidentTypeApiModel({
    required this.id,
    this.active,
    this.createBy,
    this.createDate,
    this.description,
    this.name,
    this.updateBy,
    this.updateDate,
  });

  factory IncidentTypeApiModel.fromJson(Map<String, dynamic> json) {
    return IncidentTypeApiModel(
      id: json['Id'] as int,
      active: json['Active'] as bool?,
      createBy: json['CreateBy']?.toString(),
      createDate: json['CreateDate'] != null
          ? DateTime.parse(json['CreateDate'])
          : null,
      description: json['Description']?.toString(),
      name: json['Name']?.toString(),
      updateBy: json['UpdateBy']?.toString(),
      updateDate: json['UpdateDate'] != null
          ? DateTime.parse(json['UpdateDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Active': active,
      'CreateBy': createBy,
      'CreateDate': createDate?.toIso8601String(),
      'Description': description,
      'Name': name,
      'UpdateBy': updateBy,
      'UpdateDate': updateDate?.toIso8601String(),
    };
  }
}

class UserModel {
  final String id;
  final String? username;
  final String? fullname;
  final String? email;
  final String? phoneNumber;
  final String? noNrp;
  final String? jabatan;

  const UserModel({
    required this.id,
    this.username,
    this.fullname,
    this.email,
    this.phoneNumber,
    this.noNrp,
    this.jabatan,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['Id']?.toString() ?? '',
      username: json['Username']?.toString(),
      fullname: json['Fullname']?.toString(),
      email: json['Email']?.toString(),
      phoneNumber: json['PhoneNumber']?.toString(),
      noNrp: json['NoNrp']?.toString(),
      jabatan: json['Jabatan']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Username': username,
      'Fullname': fullname,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'NoNrp': noNrp,
      'Jabatan': jabatan,
    };
  }
}

