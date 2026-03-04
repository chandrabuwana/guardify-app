class PanicButtonEditRequest {
  final String id;
  final String? action;
  final String areasId;
  final String description;
  final String? feedback;
  final int idIncidentType;
  final String reporterDate;
  final String reporterId;
  final String? resolveAction;
  final String? solverDate;
  final String? solverId;
  final String status;
  final List<PanicButtonEditFile> files;
  final PanicButtonEditFile? evidenceFile;

  const PanicButtonEditRequest({
    required this.id,
    this.action,
    required this.areasId,
    required this.description,
    this.feedback,
    required this.idIncidentType,
    required this.reporterDate,
    required this.reporterId,
    this.resolveAction,
    this.solverDate,
    this.solverId,
    required this.status,
    this.files = const [],
    this.evidenceFile,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Id': id,
      'Action': action,
      'AreasId': areasId,
      'Description': description,
      'Feedback': feedback,
      'IdIncidentType': idIncidentType,
      'ReporterDate': reporterDate,
      'ReporterId': reporterId,
      'ResolveAction': resolveAction,
      'SolverDate': solverDate,
      'SolverId': solverId,
      'Status': status,
      'Files': files.map((f) => f.toJson()).toList(),
      'EvidenceFile': evidenceFile?.toJson(),
    };
  }
}

class PanicButtonEditFile {
  final String filename;
  final String mimeType;
  final String base64;
  final int fileSize;

  const PanicButtonEditFile({
    required this.filename,
    required this.mimeType,
    required this.base64,
    required this.fileSize,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Filename': filename,
      'MimeType': mimeType,
      'Base64': base64,
      'FileSize': fileSize,
    };
  }
}
