import '../../domain/entities/incident_entity.dart';

class IncidentModel extends IncidentEntity {
  const IncidentModel({
    required super.id,
    super.incidentId,
    required super.status,
    super.pelapor,
    super.pelaporId,
    super.namaDanton,
    super.tanggalInsiden,
    super.jamInsiden,
    super.lokasiInsiden,
    super.detailLokasiInsiden,
    super.tipeInsiden,
    super.deskripsiInsiden,
    super.fotoInsiden,
    super.files,
    super.pic,
    super.picId,
    super.createDate,
    super.createBy,
    super.notesAction,
    super.solvedAction,
    super.solvedDate,
    super.incidentDetail,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id']?.toString() ?? '',
      incidentId: json['incidentId']?.toString(),
      status: _parseStatus(json['status']?.toString() ?? ''),
      pelapor: json['pelapor']?.toString(),
      pelaporId: json['pelaporId']?.toString(),
      namaDanton: json['namaDanton']?.toString(),
      tanggalInsiden: json['tanggalInsiden'] != null
          ? DateTime.parse(json['tanggalInsiden'])
          : null,
      jamInsiden: json['jamInsiden'] != null
          ? DateTime.parse(json['jamInsiden'])
          : null,
      lokasiInsiden: json['lokasiInsiden']?.toString(),
      detailLokasiInsiden: json['detailLokasiInsiden']?.toString(),
      tipeInsiden: _parseIncidentType(json['tipeInsiden']?.toString()),
      deskripsiInsiden: json['deskripsiInsiden']?.toString(),
      fotoInsiden: json['fotoInsiden']?.toString(),
      files: json['files'] != null
          ? (json['files'] as List)
              .map((f) => IncidentFile(
                    filename: f['filename']?.toString() ?? '',
                    url: f['url']?.toString() ?? '',
                  ))
              .toList()
          : [],
      pic: json['pic']?.toString(),
      picId: json['picId']?.toString(),
      createDate: json['createDate'] != null
          ? DateTime.parse(json['createDate'])
          : null,
      createBy: json['createBy']?.toString(),
      notesAction: json['notesAction']?.toString(),
      solvedAction: json['solvedAction']?.toString(),
      solvedDate: json['solvedDate'] != null
          ? DateTime.tryParse(json['solvedDate'].toString())
          : null,
      incidentDetail: json['incidentDetail'] != null
          ? (json['incidentDetail'] as List)
              .map((item) {
                if (item is Map) {
                  return Map<String, dynamic>.from(item);
                }
                return <String, dynamic>{};
              })
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'incidentId': incidentId,
      'status': _statusToString(status),
      'pelapor': pelapor,
      'pelaporId': pelaporId,
      'namaDanton': namaDanton,
      'tanggalInsiden': tanggalInsiden?.toIso8601String(),
      'jamInsiden': jamInsiden?.toIso8601String(),
      'lokasiInsiden': lokasiInsiden,
      'detailLokasiInsiden': detailLokasiInsiden,
      'tipeInsiden': tipeInsiden != null ? _incidentTypeToString(tipeInsiden!) : null,
      'deskripsiInsiden': deskripsiInsiden,
      'fotoInsiden': fotoInsiden,
      'files': files.map((f) => {'filename': f.filename, 'url': f.url}).toList(),
      'pic': pic,
      'picId': picId,
      'createDate': createDate?.toIso8601String(),
      'createBy': createBy,
      'notesAction': notesAction,
      'solvedAction': solvedAction,
      'solvedDate': solvedDate?.toIso8601String(),
      'incidentDetail': incidentDetail,
    };
  }

  factory IncidentModel.fromEntity(IncidentEntity entity) {
    return IncidentModel(
      id: entity.id,
      incidentId: entity.incidentId,
      status: entity.status,
      pelapor: entity.pelapor,
      pelaporId: entity.pelaporId,
      namaDanton: entity.namaDanton,
      tanggalInsiden: entity.tanggalInsiden,
      jamInsiden: entity.jamInsiden,
      lokasiInsiden: entity.lokasiInsiden,
      detailLokasiInsiden: entity.detailLokasiInsiden,
      tipeInsiden: entity.tipeInsiden,
      deskripsiInsiden: entity.deskripsiInsiden,
      fotoInsiden: entity.fotoInsiden,
      files: entity.files,
      pic: entity.pic,
      picId: entity.picId,
      createDate: entity.createDate,
      createBy: entity.createBy,
      notesAction: entity.notesAction,
      solvedAction: entity.solvedAction,
      solvedDate: entity.solvedDate,
      incidentDetail: entity.incidentDetail,
    );
  }

  IncidentEntity toEntity() {
    return IncidentEntity(
      id: id,
      incidentId: incidentId,
      status: status,
      pelapor: pelapor,
      pelaporId: pelaporId,
      namaDanton: namaDanton,
      tanggalInsiden: tanggalInsiden,
      jamInsiden: jamInsiden,
      lokasiInsiden: lokasiInsiden,
      detailLokasiInsiden: detailLokasiInsiden,
      tipeInsiden: tipeInsiden,
      deskripsiInsiden: deskripsiInsiden,
      fotoInsiden: fotoInsiden,
      files: files,
      pic: pic,
      picId: picId,
      createDate: createDate,
      createBy: createBy,
      notesAction: notesAction,
      solvedAction: solvedAction,
      solvedDate: solvedDate,
      incidentDetail: incidentDetail,
    );
  }

  static IncidentStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu':
        return IncidentStatus.menunggu;
      case 'diterima':
        return IncidentStatus.diterima;
      case 'ditugaskan':
        return IncidentStatus.ditugaskan;
      case 'proses':
        return IncidentStatus.proses;
      case 'eskalasi':
        return IncidentStatus.eskalasi;
      case 'selesai':
        return IncidentStatus.selesai;
      case 'terverifikasi':
        return IncidentStatus.terverifikasi;
      case 'tidak valid':
      case 'tidakvalid':
        return IncidentStatus.tidakValid;
      default:
        return IncidentStatus.menunggu;
    }
  }

  static String _statusToString(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.menunggu:
        return 'menunggu';
      case IncidentStatus.diterima:
        return 'diterima';
      case IncidentStatus.ditugaskan:
        return 'ditugaskan';
      case IncidentStatus.proses:
        return 'proses';
      case IncidentStatus.eskalasi:
        return 'eskalasi';
      case IncidentStatus.selesai:
        return 'selesai';
      case IncidentStatus.terverifikasi:
        return 'terverifikasi';
      case IncidentStatus.tidakValid:
        return 'tidak valid';
    }
  }

  static IncidentType? _parseIncidentType(String? type) {
    if (type == null) return null;
    switch (type.toLowerCase()) {
      case 'keamanan':
        return IncidentType.keamanan;
      case 'kebakaran':
        return IncidentType.kebakaran;
      case 'medis':
        return IncidentType.medis;
      case 'lainnya':
        return IncidentType.lainnya;
      default:
        return null;
    }
  }

  static String _incidentTypeToString(IncidentType type) {
    switch (type) {
      case IncidentType.keamanan:
        return 'keamanan';
      case IncidentType.kebakaran:
        return 'kebakaran';
      case IncidentType.medis:
        return 'medis';
      case IncidentType.lainnya:
        return 'lainnya';
    }
  }
}

