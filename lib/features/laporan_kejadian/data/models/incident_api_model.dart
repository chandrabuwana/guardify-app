import '../../domain/entities/incident_entity.dart';
import 'incident_model.dart';

/// Role model untuk Roles dari API response
class RoleModel {
  final String id;
  final String nama;

  const RoleModel({
    required this.id,
    required this.nama,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['Id']?.toString() ?? '',
      nama: json['Nama']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Nama': nama,
    };
  }
}

class IncidentApiModel {
  final String id;
  final String? areasDescription;
  final String? areasId;
  final dynamic areas; // Can be String or AreasModel
  final String? createBy;
  final DateTime? createDate;
  final int? idIncidentType;
  final dynamic incidentType; // Can be String or IncidentTypeApiModel
  final DateTime? incidentDate;
  final String? incidentTime;
  final String? incidentDescription;
  final String? notesAction;
  final String? picId;
  final dynamic pic; // Can be String or UserModel
  final String? picPhoto;
  final String? pjId;
  final dynamic pj; // Can be String or UserModel
  final String? reportId;
  final dynamic report; // Can be String or UserModel
  final String? solvedAction;
  final DateTime? solvedDate;
  final String? status;
  final String? evidence;
  final String? updateBy;
  final DateTime? updateDate;
  final dynamic incidentDetail; // Can be Map or List
  final List<dynamic>? teams;
  final List<RoleModel>? roles; // Roles dari pelapor (Reporter)
  final String? reviewedBy;
  final DateTime? reviewedDate;
  final String? handlingTask;
  final String? feedBack;
  final String? supervisorFeedback;
  final String? verifiedBy;
  final DateTime? verifiedDate;
  final String? completedBy;
  final DateTime? incidentCompletionDate;

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
    this.picPhoto,
    this.pjId,
    this.pj,
    this.reportId,
    this.report,
    this.solvedAction,
    this.solvedDate,
    this.status,
    this.evidence,
    this.updateBy,
    this.updateDate,
    this.incidentDetail,
    this.teams,
    this.roles,
    this.reviewedBy,
    this.reviewedDate,
    this.handlingTask,
    this.feedBack,
    this.supervisorFeedback,
    this.verifiedBy,
    this.verifiedDate,
    this.completedBy,
    this.incidentCompletionDate,
  });

  factory IncidentApiModel.fromJson(Map<String, dynamic> json) {
    // Handle areas - can be String or Map
    dynamic areas;
    if (json['Areas'] != null) {
      if (json['Areas'] is String) {
        areas = json['Areas'];
      } else if (json['Areas'] is Map<String, dynamic>) {
        areas = AreasModel.fromJson(json['Areas'] as Map<String, dynamic>);
      }
    }

    // Handle incidentType - can be String or Map
    dynamic incidentType;
    if (json['IncidentType'] != null) {
      if (json['IncidentType'] is String) {
        incidentType = json['IncidentType'];
      } else if (json['IncidentType'] is Map<String, dynamic>) {
        incidentType = IncidentTypeApiModel.fromJson(json['IncidentType'] as Map<String, dynamic>);
      }
    }

    // Handle pic - can be String or Map
    dynamic pic;
    if (json['Pic'] != null) {
      if (json['Pic'] is String) {
        pic = json['Pic'];
      } else if (json['Pic'] is Map<String, dynamic>) {
        pic = UserModel.fromJson(json['Pic'] as Map<String, dynamic>);
      }
    }

    // Handle pj - can be String or Map
    dynamic pj;
    if (json['Pj'] != null) {
      if (json['Pj'] is String) {
        pj = json['Pj'];
      } else if (json['Pj'] is Map<String, dynamic>) {
        pj = UserModel.fromJson(json['Pj'] as Map<String, dynamic>);
      }
    }

    // Handle report - can be String or Map
    dynamic report;
    if (json['Report'] != null) {
      if (json['Report'] is String) {
        report = json['Report'];
      } else if (json['Report'] is Map<String, dynamic>) {
        report = UserModel.fromJson(json['Report'] as Map<String, dynamic>);
      }
    }

    // Handle solvedDate - can be "0001-01-01T00:00:00" which should be null
    DateTime? solvedDate;
    if (json['SolvedDate'] != null) {
      final solvedDateStr = json['SolvedDate'].toString();
      if (solvedDateStr != '0001-01-01T00:00:00' && solvedDateStr.isNotEmpty) {
        solvedDate = DateTime.tryParse(solvedDateStr);
      }
    }

    return IncidentApiModel(
      id: json['Id']?.toString() ?? '',
      areasDescription: json['AreasDescription']?.toString(),
      areasId: json['AreasId']?.toString(),
      areas: areas,
      createBy: json['CreateBy']?.toString(),
      createDate: json['CreateDate'] != null
          ? DateTime.tryParse(json['CreateDate'].toString())
          : null,
      idIncidentType: json['IdIncidentType'] as int?,
      incidentType: incidentType,
      incidentDate: json['IncidentDate'] != null
          ? DateTime.tryParse(json['IncidentDate'].toString())
          : null,
      incidentTime: json['IncidentTime']?.toString(),
      incidentDescription: json['IncidentDescription']?.toString(),
      notesAction: json['NotesAction']?.toString(),
      picId: json['PicId']?.toString(),
      pic: pic,
      picPhoto: json['PicPhoto']?.toString(),
      pjId: json['PjId']?.toString(),
      pj: pj,
      reportId: json['ReportId']?.toString(),
      report: report,
      solvedAction: json['SolvedAction']?.toString(),
      solvedDate: solvedDate,
      status: json['Status']?.toString(),
      evidence: json['Evidence']?.toString(),
      updateBy: json['UpdateBy']?.toString(),
      updateDate: json['UpdateDate'] != null
          ? DateTime.tryParse(json['UpdateDate'].toString())
          : null,
      incidentDetail: json['IncidentDetail'], // Can be Map or List
      teams: json['Teams'] as List<dynamic>?,
      roles: json['Roles'] != null
          ? (json['Roles'] as List)
              .map((r) => RoleModel.fromJson(r as Map<String, dynamic>))
              .toList()
          : null,
      reviewedBy: json['ReviewedBy']?.toString(),
      reviewedDate: json['ReviewedDate'] != null
          ? DateTime.tryParse(json['ReviewedDate'].toString())
          : null,
      handlingTask: json['HandlingTask']?.toString(),
      feedBack: json['FeedBack']?.toString(),
      supervisorFeedback: json['SupervisorFeedback']?.toString(),
      verifiedBy: json['VerifiedBy']?.toString(),
      verifiedDate: json['VerifiedDate'] != null
          ? DateTime.tryParse(json['VerifiedDate'].toString())
          : null,
      completedBy: json['CompletedBy']?.toString(),
      incidentCompletionDate: json['IncidentCompletionDate'] != null
          ? DateTime.tryParse(json['IncidentCompletionDate'].toString())
          : null,
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
      'Roles': roles?.map((r) => r.toJson()).toList(),
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
    String? incidentTypeName;
    if (incidentType != null && incidentType is IncidentTypeApiModel) {
      incidentTypeName = (incidentType as IncidentTypeApiModel).name;
    } else if (incidentType is String) {
      incidentTypeName = incidentType;
    }
    
    if (incidentTypeName != null && incidentTypeName.isNotEmpty) {
      switch (incidentTypeName.toLowerCase()) {
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
      pelapor: report is UserModel ? report.fullname : (report is String ? report : null),
      pelaporId: reportId,
      namaDanton: pj is UserModel ? pj.fullname : (pj is String ? pj : null),
      tanggalInsiden: incidentDate,
      jamInsiden: combinedDateTime ?? incidentDate,
      lokasiInsiden: (areas is AreasModel ? areas.name : (areas is String ? areas : null)) ?? areasDescription,
      detailLokasiInsiden: areasDescription,
      tipeInsiden: incidentTypeEnum,
      deskripsiInsiden: incidentDescription ?? '',
      pic: pic is UserModel ? pic.fullname : (pic is String ? pic : null),
      picId: picId,
      createDate: createDate,
      createBy: createBy,
      notesAction: notesAction,
      solvedAction: solvedAction,
      solvedDate: solvedDate,
      incidentDetail: () {
        // IMPORTANT: Only use Teams for team display
        // If Teams is empty, return empty list (don't use IncidentDetail as fallback for team display)
        // IncidentDetail is preserved separately in the model for other data (HandlingTask, ActionTakenNote, etc.)
        final List<Map<String, dynamic>> result = [];
        final List<Map<String, dynamic>> incidentDetailList = [];
        
        // Collect IncidentDetail data first (for merging with Teams only)
        if (incidentDetail != null) {
          if (incidentDetail is Map<String, dynamic>) {
            incidentDetailList.add(Map<String, dynamic>.from(incidentDetail));
          } else if (incidentDetail is List) {
            for (var item in incidentDetail as List) {
              if (item is Map) {
                incidentDetailList.add(Map<String, dynamic>.from(item));
              }
            }
          }
        }
        
        // Only use Teams for team display - if Teams is empty, return empty list
        if (teams != null && teams!.isNotEmpty) {
          for (var team in teams!) {
            if (team is Map<String, dynamic>) {
              final teamMap = Map<String, dynamic>.from(team);
              final teamUserId = teamMap['UserId']?.toString() ?? '';
              final teamUserName = teamMap['UserName']?.toString() ?? '';
              
              // Find matching IncidentDetail by UserId or UserName
              Map<String, dynamic>? matchingDetail;
              if (teamUserId.isNotEmpty) {
                // Try to match by UserId first
                try {
                  matchingDetail = incidentDetailList.firstWhere(
                    (item) {
                      final itemUserId = item['UserId']?.toString() ?? '';
                      return itemUserId.isNotEmpty && itemUserId == teamUserId;
                    },
                  );
                } catch (e) {
                  matchingDetail = null;
                }
              }
              
              // If no match by UserId and we have UserName, try to match by UserName
              if (matchingDetail == null && teamUserName.isNotEmpty) {
                try {
                  matchingDetail = incidentDetailList.firstWhere(
                    (item) {
                      final itemUserName = item['UserName']?.toString() ?? '';
                      return itemUserName.isNotEmpty && itemUserName.toLowerCase() == teamUserName.toLowerCase();
                    },
                  );
                } catch (e) {
                  matchingDetail = null;
                }
              }
              
              // Merge: use Team data (has UserName) and add detailed info from IncidentDetail
              final merged = Map<String, dynamic>.from(teamMap);
              if (matchingDetail != null) {
                // Add detailed info from IncidentDetail but keep UserName from Teams
                merged.addAll(matchingDetail);
                // Ensure UserName from Teams is preserved
                if (teamMap['UserName'] != null) {
                  merged['UserName'] = teamMap['UserName'];
                }
                // Ensure UserPhoto from Teams is preserved
                if (teamMap['UserPhoto'] != null) {
                  merged['UserPhoto'] = teamMap['UserPhoto'];
                }
                // Ensure UserId from IncidentDetail is preserved (if Teams doesn't have it)
                if (teamUserId.isEmpty && matchingDetail['UserId'] != null) {
                  merged['UserId'] = matchingDetail['UserId'];
                }
              }
              
              result.add(merged);
            }
          }
        }
        // If Teams is empty, return empty list (don't use IncidentDetail as fallback for team display)
        // Note: Original IncidentDetail is still available in incidentDetail field for other purposes (HandlingTask, etc.)
        
        return result.isNotEmpty ? result : null;
      }(),
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
