class PanicButtonHistoryItem {
  final String id;
  final String? action;
  final String areasId;
  final String? areaName;
  final String? createBy;
  final DateTime? createDate;
  final String description;
  final String? feedback;
  final int idIncidentType;
  final String? incidentTypeName;
  final DateTime? reporterDate;
  final String reporterId;
  final String? reporterName;
  final String? reporterNrp;
  final String? resolveAction;
  final DateTime? solverDate;
  final String? solverId;
  final String? solverName;
  final String? solverNrp;
  final String status;
  final List<PanicButtonHistoryFile> files;
  final PanicButtonHistoryFile? evidenceFile;

  PanicButtonHistoryItem({
    required this.id,
    this.action,
    required this.areasId,
    this.areaName,
    this.createBy,
    this.createDate,
    required this.description,
    this.feedback,
    required this.idIncidentType,
    this.incidentTypeName,
    this.reporterDate,
    required this.reporterId,
    this.reporterName,
    this.reporterNrp,
    this.resolveAction,
    this.solverDate,
    this.solverId,
    this.solverName,
    this.solverNrp,
    required this.status,
    this.files = const [],
    this.evidenceFile,
  });

  // Get formatted ID (e.g., PNC09272)
  String get formattedId {
    if (id.length >= 8) {
      return 'PNC${id.substring(0, 5).toUpperCase()}';
    }
    return 'PNC${id.substring(0, id.length).toUpperCase()}';
  }

  // Get status color
  PanicButtonStatusColor get statusColor {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return PanicButtonStatusColor.red;
      case 'DONE':
        return PanicButtonStatusColor.orange;
      case 'VERIFIED':
        return PanicButtonStatusColor.blue;
      case 'COMPLETED':
        return PanicButtonStatusColor.blue;
      case 'REVISI':
      case 'REVISION':
      case 'REVISED':
        return PanicButtonStatusColor.orange;
      case 'CLOSED':
        return PanicButtonStatusColor.blue;
      default:
        return PanicButtonStatusColor.grey;
    }
  }
}

class PanicButtonHistoryFile {
  final String filename;
  final String url;

  PanicButtonHistoryFile({
    required this.filename,
    required this.url,
  });
}

enum PanicButtonStatusColor {
  red,
  orange,
  blue,
  grey,
}

