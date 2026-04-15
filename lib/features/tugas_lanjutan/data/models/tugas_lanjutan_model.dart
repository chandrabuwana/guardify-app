import '../../domain/entities/tugas_lanjutan_entity.dart';

/// Model untuk Tugas Lanjutan
class TugasLanjutanModel extends TugasLanjutanEntity {
  const TugasLanjutanModel({
    required super.id,
    required super.title,
    required super.lokasi,
    required super.pelapor,
    required super.tanggal,
    required super.deskripsi,
    required super.status,
    super.diselesaikanOleh,
    super.diselesaikanOlehId,
    super.tanggalSelesai,
    super.buktiUrl,
    super.catatan,
  });

  factory TugasLanjutanModel.fromJson(Map<String, dynamic> json) {
    return TugasLanjutanModel(
      id: json['id'] as String,
      title: json['title'] as String,
      lokasi: json['lokasi'] as String,
      pelapor: json['pelapor'] as String,
      tanggal: DateTime.parse(json['tanggal'] as String),
      deskripsi: json['deskripsi'] as String,
      status: TugasLanjutanStatus.fromValue(
        json['status'] as String? ?? 'belum',
      ),
      diselesaikanOleh: json['diselesaikan_oleh'] as String?,
      diselesaikanOlehId: json['diselesaikan_oleh_id'] as String?,
      tanggalSelesai: json['tanggal_selesai'] != null
          ? DateTime.parse(json['tanggal_selesai'] as String)
          : null,
      buktiUrl: json['bukti_url'] as String?,
      catatan: json['catatan'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lokasi': lokasi,
      'pelapor': pelapor,
      'tanggal': tanggal.toIso8601String(),
      'deskripsi': deskripsi,
      'status': status.value,
      'diselesaikan_oleh': diselesaikanOleh,
      'diselesaikan_oleh_id': diselesaikanOlehId,
      'tanggal_selesai': tanggalSelesai?.toIso8601String(),
      'bukti_url': buktiUrl,
      'catatan': catatan,
    };
  }

  factory TugasLanjutanModel.fromEntity(TugasLanjutanEntity entity) {
    return TugasLanjutanModel(
      id: entity.id,
      title: entity.title,
      lokasi: entity.lokasi,
      pelapor: entity.pelapor,
      tanggal: entity.tanggal,
      deskripsi: entity.deskripsi,
      status: entity.status,
      diselesaikanOleh: entity.diselesaikanOleh,
      diselesaikanOlehId: entity.diselesaikanOlehId,
      tanggalSelesai: entity.tanggalSelesai,
      buktiUrl: entity.buktiUrl,
      catatan: entity.catatan,
    );
  }

  TugasLanjutanEntity toEntity() {
    return TugasLanjutanEntity(
      id: id,
      title: title,
      lokasi: lokasi,
      pelapor: pelapor,
      tanggal: tanggal,
      deskripsi: deskripsi,
      status: status,
      diselesaikanOleh: diselesaikanOleh,
      diselesaikanOlehId: diselesaikanOlehId,
      tanggalSelesai: tanggalSelesai,
      buktiUrl: buktiUrl,
      catatan: catatan,
    );
  }
}

