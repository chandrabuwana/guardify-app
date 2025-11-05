import '../../../../core/constants/enums.dart';
import '../../domain/entities/laporan_kegiatan_entity.dart';

/// Model untuk Laporan Kegiatan
class LaporanKegiatanModel extends LaporanKegiatanEntity {
  const LaporanKegiatanModel({
    required super.id,
    required super.namaPersonil,
    required super.userId,
    required super.role,
    super.profileImageUrl,
    required super.nrp,
    required super.tanggal,
    required super.shift,
    required super.jamKerja,
    required super.lokasiJaga,
    super.jamAbsensi,
    super.pakaianPersonil,
    super.fotoPakaianPersonil,
    required super.laporanPengamanan,
    super.fotoPengamanan,
    super.tugasLanjutan,
    required super.tugasTertunda,
    required super.status,
    required super.kehadiran,
    required super.lembur,
    super.fotoLembur,
    super.jamSelesaiBekerja,
    super.umpanBalik,
    super.routeName,
    super.checkpoints,
    super.reviewerId,
    super.reviewerName,
    super.tanggalReview,
  });

  factory LaporanKegiatanModel.fromJson(Map<String, dynamic> json) {
    return LaporanKegiatanModel(
      id: json['id'] as String,
      namaPersonil: json['nama_personil'] as String,
      userId: json['user_id'] as String,
      role: UserRole.fromValue(json['role'] as String? ?? 'anggota'),
      profileImageUrl: json['profile_image_url'] as String?,
      nrp: json['nrp'] as String,
      tanggal: DateTime.parse(json['tanggal'] as String),
      shift: json['shift'] as String,
      jamKerja: json['jam_kerja'] as String,
      lokasiJaga: json['lokasi_jaga'] as String,
      jamAbsensi: json['jam_absensi'] as String?,
      pakaianPersonil: json['pakaian_personil'] as String?,
      fotoPakaianPersonil: json['foto_pakaian_personil'] as String?,
      laporanPengamanan: json['laporan_pengamanan'] as String,
      fotoPengamanan: json['foto_pengamanan'] != null
          ? List<String>.from(json['foto_pengamanan'] as List)
          : null,
      tugasLanjutan: json['tugas_lanjutan'] as String?,
      tugasTertunda: json['tugas_tertunda'] as bool? ?? false,
      status: LaporanStatus.fromValue(
        json['status'] as String? ?? 'menunggu_verifikasi',
      ),
      kehadiran: json['kehadiran'] as String? ?? 'Masuk',
      lembur: json['lembur'] as bool? ?? false,
      fotoLembur: json['foto_lembur'] as String?,
      jamSelesaiBekerja: json['jam_selesai_bekerja'] as String?,
      umpanBalik: json['umpan_balik'] as String?,
      routeName: json['route_name'] as String?,
      checkpoints: json['checkpoints'] != null
          ? (json['checkpoints'] as List)
              .map((e) => PatrolCheckpointModel.fromJson(e))
              .toList()
          : null,
      reviewerId: json['reviewer_id'] as String?,
      reviewerName: json['reviewer_name'] as String?,
      tanggalReview: json['tanggal_review'] != null
          ? DateTime.parse(json['tanggal_review'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_personil': namaPersonil,
      'user_id': userId,
      'role': role.value,
      'profile_image_url': profileImageUrl,
      'nrp': nrp,
      'tanggal': tanggal.toIso8601String(),
      'shift': shift,
      'jam_kerja': jamKerja,
      'lokasi_jaga': lokasiJaga,
      'jam_absensi': jamAbsensi,
      'pakaian_personil': pakaianPersonil,
      'foto_pakaian_personil': fotoPakaianPersonil,
      'laporan_pengamanan': laporanPengamanan,
      'foto_pengamanan': fotoPengamanan,
      'tugas_lanjutan': tugasLanjutan,
      'tugas_tertunda': tugasTertunda,
      'status': status.value,
      'kehadiran': kehadiran,
      'lembur': lembur,
      'foto_lembur': fotoLembur,
      'jam_selesai_bekerja': jamSelesaiBekerja,
      'umpan_balik': umpanBalik,
      'route_name': routeName,
      'checkpoints': checkpoints
          ?.map((e) => (e as PatrolCheckpointModel).toJson())
          .toList(),
      'reviewer_id': reviewerId,
      'reviewer_name': reviewerName,
      'tanggal_review': tanggalReview?.toIso8601String(),
    };
  }

  factory LaporanKegiatanModel.fromEntity(LaporanKegiatanEntity entity) {
    return LaporanKegiatanModel(
      id: entity.id,
      namaPersonil: entity.namaPersonil,
      userId: entity.userId,
      role: entity.role,
      profileImageUrl: entity.profileImageUrl,
      nrp: entity.nrp,
      tanggal: entity.tanggal,
      shift: entity.shift,
      jamKerja: entity.jamKerja,
      lokasiJaga: entity.lokasiJaga,
      jamAbsensi: entity.jamAbsensi,
      pakaianPersonil: entity.pakaianPersonil,
      fotoPakaianPersonil: entity.fotoPakaianPersonil,
      laporanPengamanan: entity.laporanPengamanan,
      fotoPengamanan: entity.fotoPengamanan,
      tugasLanjutan: entity.tugasLanjutan,
      tugasTertunda: entity.tugasTertunda,
      status: entity.status,
      kehadiran: entity.kehadiran,
      lembur: entity.lembur,
      fotoLembur: entity.fotoLembur,
      jamSelesaiBekerja: entity.jamSelesaiBekerja,
      umpanBalik: entity.umpanBalik,
      routeName: entity.routeName,
      checkpoints: entity.checkpoints,
      reviewerId: entity.reviewerId,
      reviewerName: entity.reviewerName,
      tanggalReview: entity.tanggalReview,
    );
  }

  LaporanKegiatanEntity toEntity() {
    return LaporanKegiatanEntity(
      id: id,
      namaPersonil: namaPersonil,
      userId: userId,
      role: role,
      profileImageUrl: profileImageUrl,
      nrp: nrp,
      tanggal: tanggal,
      shift: shift,
      jamKerja: jamKerja,
      lokasiJaga: lokasiJaga,
      jamAbsensi: jamAbsensi,
      pakaianPersonil: pakaianPersonil,
      fotoPakaianPersonil: fotoPakaianPersonil,
      laporanPengamanan: laporanPengamanan,
      fotoPengamanan: fotoPengamanan,
      tugasLanjutan: tugasLanjutan,
      tugasTertunda: tugasTertunda,
      status: status,
      kehadiran: kehadiran,
      lembur: lembur,
      fotoLembur: fotoLembur,
      jamSelesaiBekerja: jamSelesaiBekerja,
      umpanBalik: umpanBalik,
      routeName: routeName,
      checkpoints: checkpoints,
      reviewerId: reviewerId,
      reviewerName: reviewerName,
      tanggalReview: tanggalReview,
    );
  }
}

/// Model untuk PatrolCheckpoint
class PatrolCheckpointModel extends PatrolCheckpoint {
  const PatrolCheckpointModel({
    required super.id,
    required super.name,
    required super.status,
    super.timestamp,
    super.buktiUrl,
    super.isDiperiksa,
  });

  factory PatrolCheckpointModel.fromJson(Map<String, dynamic> json) {
    return PatrolCheckpointModel(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
      buktiUrl: json['bukti_url'] as String?,
      isDiperiksa: json['is_diperiksa'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'timestamp': timestamp?.toIso8601String(),
      'bukti_url': buktiUrl,
      'is_diperiksa': isDiperiksa,
    };
  }
}
