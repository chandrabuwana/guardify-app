import 'package:equatable/equatable.dart';

enum IncidentStatus {
  menunggu,      // Menunggu
  diterima,      // Diterima
  ditugaskan,    // Ditugaskan
  proses,        // Proses
  eskalasi,      // Eskalasi
  selesai,       // Selesai
  terverifikasi, // Terverifikasi
  tidakValid,    // Tidak Valid
}

enum IncidentType {
  keamanan,      // Keamanan
  kebakaran,     // Kebakaran
  medis,         // Medis
  lainnya,       // Lainnya
}

class IncidentEntity extends Equatable {
  final String id;
  final String? incidentId; // Formatted ID like LV0022831
  final IncidentStatus status;
  final String? pelapor; // Reporter name
  final String? pelaporId; // Reporter ID
  final String? namaDanton; // Danton name
  final DateTime? tanggalInsiden; // Incident date
  final DateTime? jamInsiden; // Incident time
  final String? lokasiInsiden; // Incident location
  final String? detailLokasiInsiden; // Detailed location
  final IncidentType? tipeInsiden; // Incident type
  final String? deskripsiInsiden; // Description
  final String? fotoInsiden; // Photo URL or filename
  final List<IncidentFile> files; // List of files
  final String? pic; // Person in charge
  final String? picId; // PIC ID
  final DateTime? createDate; // Created date
  final String? createBy; // Created by
  final String? notesAction; // Tugas Penanganan / Notes Action
  final String? solvedAction; // Note Penyelesaian / Solved Action
  final DateTime? solvedDate; // Tanggal Penyelesaian / Solved Date
  final List<Map<String, dynamic>>? incidentDetail; // Detail insiden (untuk Tim Petugas dll)

  const IncidentEntity({
    required this.id,
    this.incidentId,
    required this.status,
    this.pelapor,
    this.pelaporId,
    this.namaDanton,
    this.tanggalInsiden,
    this.jamInsiden,
    this.lokasiInsiden,
    this.detailLokasiInsiden,
    this.tipeInsiden,
    this.deskripsiInsiden,
    this.fotoInsiden,
    this.files = const [],
    this.pic,
    this.picId,
    this.createDate,
    this.createBy,
    this.notesAction,
    this.solvedAction,
    this.solvedDate,
    this.incidentDetail,
  });

  String get formattedId {
    if (incidentId != null && incidentId!.isNotEmpty) {
      return incidentId!;
    }
    if (id.length >= 8) {
      return 'LV${id.substring(0, 7).toUpperCase()}';
    }
    return 'LV${id.toUpperCase()}';
  }

  String get statusDisplayName {
    switch (status) {
      case IncidentStatus.menunggu:
        return 'Menunggu';
      case IncidentStatus.diterima:
        return 'Diterima';
      case IncidentStatus.ditugaskan:
        return 'Ditugaskan';
      case IncidentStatus.proses:
        return 'Proses';
      case IncidentStatus.eskalasi:
        return 'Eskalasi';
      case IncidentStatus.selesai:
        return 'Selesai';
      case IncidentStatus.terverifikasi:
        return 'Terverifikasi';
      case IncidentStatus.tidakValid:
        return 'Tidak Valid';
    }
  }

  String get tipeInsidenDisplayName {
    switch (tipeInsiden) {
      case IncidentType.keamanan:
        return 'Keamanan';
      case IncidentType.kebakaran:
        return 'Kebakaran';
      case IncidentType.medis:
        return 'Medis';
      case IncidentType.lainnya:
        return 'Lainnya';
      case null:
        return '-';
    }
  }

  IncidentStatusColor get statusColor {
    switch (status) {
      case IncidentStatus.menunggu:
      case IncidentStatus.eskalasi:
        return IncidentStatusColor.red;
      case IncidentStatus.diterima:
        return IncidentStatusColor.orange;
      case IncidentStatus.ditugaskan:
        return IncidentStatusColor.yellow;
      case IncidentStatus.proses:
        return IncidentStatusColor.blue;
      case IncidentStatus.selesai:
        return IncidentStatusColor.purple;
      case IncidentStatus.terverifikasi:
        return IncidentStatusColor.green;
      case IncidentStatus.tidakValid:
        return IncidentStatusColor.lightYellow;
    }
  }

  IncidentEntity copyWith({
    String? id,
    String? incidentId,
    IncidentStatus? status,
    String? pelapor,
    String? pelaporId,
    String? namaDanton,
    DateTime? tanggalInsiden,
    DateTime? jamInsiden,
    String? lokasiInsiden,
    String? detailLokasiInsiden,
    IncidentType? tipeInsiden,
    String? deskripsiInsiden,
    String? fotoInsiden,
    List<IncidentFile>? files,
    String? pic,
    String? picId,
    DateTime? createDate,
    String? createBy,
    String? notesAction,
    String? solvedAction,
    DateTime? solvedDate,
    List<Map<String, dynamic>>? incidentDetail,
  }) {
    return IncidentEntity(
      id: id ?? this.id,
      incidentId: incidentId ?? this.incidentId,
      status: status ?? this.status,
      pelapor: pelapor ?? this.pelapor,
      pelaporId: pelaporId ?? this.pelaporId,
      namaDanton: namaDanton ?? this.namaDanton,
      tanggalInsiden: tanggalInsiden ?? this.tanggalInsiden,
      jamInsiden: jamInsiden ?? this.jamInsiden,
      lokasiInsiden: lokasiInsiden ?? this.lokasiInsiden,
      detailLokasiInsiden: detailLokasiInsiden ?? this.detailLokasiInsiden,
      tipeInsiden: tipeInsiden ?? this.tipeInsiden,
      deskripsiInsiden: deskripsiInsiden ?? this.deskripsiInsiden,
      fotoInsiden: fotoInsiden ?? this.fotoInsiden,
      files: files ?? this.files,
      pic: pic ?? this.pic,
      picId: picId ?? this.picId,
      createDate: createDate ?? this.createDate,
      createBy: createBy ?? this.createBy,
      notesAction: notesAction ?? this.notesAction,
      solvedAction: solvedAction ?? this.solvedAction,
      solvedDate: solvedDate ?? this.solvedDate,
      incidentDetail: incidentDetail ?? this.incidentDetail,
    );
  }

  @override
  List<Object?> get props => [
        id,
        incidentId,
        status,
        pelapor,
        pelaporId,
        namaDanton,
        tanggalInsiden,
        jamInsiden,
        lokasiInsiden,
        detailLokasiInsiden,
        tipeInsiden,
        deskripsiInsiden,
        fotoInsiden,
        files,
        pic,
        picId,
        createDate,
        createBy,
        notesAction,
        solvedAction,
        solvedDate,
        incidentDetail,
      ];
}

class IncidentFile extends Equatable {
  final String filename;
  final String url;

  const IncidentFile({
    required this.filename,
    required this.url,
  });

  @override
  List<Object?> get props => [filename, url];
}

enum IncidentStatusColor {
  red,
  orange,
  yellow,
  blue,
  purple,
  green,
  lightYellow,
}

