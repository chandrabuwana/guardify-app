import 'create_incident_request.dart';

/// Evidence model untuk UpdateAllIncident
class EvidenceModel {
  final String filename;
  final String mimeType;
  final String base64;
  final int fileSize;

  EvidenceModel({
    required this.filename,
    required this.mimeType,
    required this.base64,
    required this.fileSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'Filename': filename,
      'MimeType': mimeType,
      'Base64': base64,
      'FileSize': fileSize,
    };
  }

  factory EvidenceModel.fromMap(Map<String, dynamic> map) {
    return EvidenceModel(
      filename: map['Filename']?.toString() ?? '',
      mimeType: map['MimeType']?.toString() ?? '',
      base64: map['Base64']?.toString() ?? '',
      fileSize: (map['FileSize'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Request model untuk UpdateAllIncident API
class UpdateAllIncidentRequest {
  final String id;
  final String? areasDescription;
  final String? areasId;
  final int? idIncidentType;
  final DateTime? incidentDate;
  final String? incidentTime;
  final String? incidentDescription;
  final String? reportId;
  final String? picId;
  final List<String> team;
  final String? handlingTask;
  final String? notes;
  final String? feedBack;
  final EvidenceModel? evidence;
  final String status;
  final String? solvedAction;
  final DateTime? solvedDate;
  final DateTime? incidentCompletionDate;
  final String? completedBy;
  final String? verifiedBy;
  final DateTime? verifiedDate;
  final String? reviewedBy;
  final DateTime? reviewedDate;
  final String? supervisorFeedback;
  final String? createBy;
  final DateTime? createDate;
  final String? updateBy;
  final DateTime? updateDate;
  final TokenModel? token;

  UpdateAllIncidentRequest({
    required this.id,
    this.areasDescription,
    this.areasId,
    this.idIncidentType,
    this.incidentDate,
    this.incidentTime,
    this.incidentDescription,
    this.reportId,
    this.picId,
    required this.team,
    this.handlingTask,
    this.notes,
    this.feedBack,
    this.evidence,
    required this.status,
    this.solvedAction,
    this.solvedDate,
    this.incidentCompletionDate,
    this.completedBy,
    this.verifiedBy,
    this.verifiedDate,
    this.reviewedBy,
    this.reviewedDate,
    this.supervisorFeedback,
    this.createBy,
    this.createDate,
    this.updateBy,
    this.updateDate,
    this.token,
  });

  Map<String, dynamic> toJson() {
    // Semua field harus dikirim dengan default value sesuai tipe datanya
    // String: "" (empty string) jika null
    // GUID: default GUID untuk PicId dan ReviewedBy jika null atau kosong
    // DateTime: null jika null, CreateDate hanya dikirim jika ada value
    // Array: [] jika null
    // Object: null jika null
    const defaultGuid = '00000000-0000-0000-0000-000000000000';
    
    final json = <String, dynamic>{
      'Id': id,
      'Team': team.isNotEmpty ? team : [],
      'Status': status,
      'AreasDescription': areasDescription ?? '',
      'AreasId': areasId ?? '',
      'IdIncidentType': idIncidentType,
      'IncidentDate': incidentDate?.toIso8601String(),
      'IncidentTime': incidentTime ?? '',
      'IncidentDescription': incidentDescription ?? '',
      'ReportId': reportId ?? '',
      // PicId menggunakan default GUID jika null atau kosong
      'PicId': (picId != null && picId!.isNotEmpty) ? picId : defaultGuid,
      'HandlingTask': handlingTask ?? '',
      'Notes': notes ?? '',
      'FeedBack': feedBack ?? '',
      'Evidence': evidence?.toJson(),
      'SolvedAction': solvedAction ?? '',
      'SolvedDate': solvedDate?.toIso8601String(),
      'IncidentCompletionDate': incidentCompletionDate?.toIso8601String(),
      // CompletedBy, VerifiedBy dikirim null jika null atau kosong (sesuai response /incident/getall)
      'CompletedBy': (completedBy != null && completedBy!.isNotEmpty) ? completedBy : null,
      'VerifiedBy': (verifiedBy != null && verifiedBy!.isNotEmpty) ? verifiedBy : null,
      'VerifiedDate': verifiedDate?.toIso8601String(),
      // ReviewedBy: kirim null jika null atau empty (bukan default GUID)
      // Default GUID hanya untuk PicId, bukan untuk ReviewedBy
      'ReviewedBy': (reviewedBy != null && reviewedBy!.isNotEmpty && reviewedBy != defaultGuid) ? reviewedBy : null,
      'ReviewedDate': reviewedDate?.toIso8601String(),
      'SupervisorFeedback': supervisorFeedback ?? '',
      'CreateBy': createBy ?? '',
      'UpdateBy': updateBy ?? '',
      'UpdateDate': updateDate?.toIso8601String(),
      'Token': token?.toJson(),
    };

    // CreateDate hanya dikirim jika ada value (diambil dari response /incident/getall)
    if (createDate != null) {
      json['CreateDate'] = createDate!.toIso8601String();
    }

    return json;
  }
}
