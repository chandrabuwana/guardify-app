import '../../domain/entities/cuti_entity.dart';

class CutiModel extends CutiEntity {
  const CutiModel({
    required super.id,
    required super.nama,
    required super.userId,
    required super.tipeCuti,
    required super.tanggalMulai,
    required super.tanggalSelesai,
    required super.alasan,
    required super.status,
    super.umpanBalik,
    super.reviewerId,
    super.reviewerName,
    required super.tanggalPengajuan,
    super.tanggalReview,
    required super.jumlahHari,
  });

  factory CutiModel.fromJson(Map<String, dynamic> json) {
    return CutiModel(
      id: json['id'],
      nama: json['nama'],
      userId: json['userId'],
      tipeCuti: CutiType.values.firstWhere(
        (e) => e.toString().split('.').last == json['tipeCuti'],
      ),
      tanggalMulai: DateTime.parse(json['tanggalMulai']),
      tanggalSelesai: DateTime.parse(json['tanggalSelesai']),
      alasan: json['alasan'],
      status: CutiStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      umpanBalik: json['umpanBalik'],
      reviewerId: json['reviewerId'],
      reviewerName: json['reviewerName'],
      tanggalPengajuan: DateTime.parse(json['tanggalPengajuan']),
      tanggalReview: json['tanggalReview'] != null
          ? DateTime.parse(json['tanggalReview'])
          : null,
      jumlahHari: json['jumlahHari'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'userId': userId,
      'tipeCuti': tipeCuti.toString().split('.').last,
      'tanggalMulai': tanggalMulai.toIso8601String(),
      'tanggalSelesai': tanggalSelesai.toIso8601String(),
      'alasan': alasan,
      'status': status.toString().split('.').last,
      'umpanBalik': umpanBalik,
      'reviewerId': reviewerId,
      'reviewerName': reviewerName,
      'tanggalPengajuan': tanggalPengajuan.toIso8601String(),
      'tanggalReview': tanggalReview?.toIso8601String(),
      'jumlahHari': jumlahHari,
    };
  }

  factory CutiModel.fromEntity(CutiEntity entity) {
    return CutiModel(
      id: entity.id,
      nama: entity.nama,
      userId: entity.userId,
      tipeCuti: entity.tipeCuti,
      tanggalMulai: entity.tanggalMulai,
      tanggalSelesai: entity.tanggalSelesai,
      alasan: entity.alasan,
      status: entity.status,
      umpanBalik: entity.umpanBalik,
      reviewerId: entity.reviewerId,
      reviewerName: entity.reviewerName,
      tanggalPengajuan: entity.tanggalPengajuan,
      tanggalReview: entity.tanggalReview,
      jumlahHari: entity.jumlahHari,
    );
  }

  CutiEntity toEntity() {
    return CutiEntity(
      id: id,
      nama: nama,
      userId: userId,
      tipeCuti: tipeCuti,
      tanggalMulai: tanggalMulai,
      tanggalSelesai: tanggalSelesai,
      alasan: alasan,
      status: status,
      umpanBalik: umpanBalik,
      reviewerId: reviewerId,
      reviewerName: reviewerName,
      tanggalPengajuan: tanggalPengajuan,
      tanggalReview: tanggalReview,
      jumlahHari: jumlahHari,
    );
  }
}
