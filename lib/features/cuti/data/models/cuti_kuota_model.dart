import '../../domain/entities/cuti_kuota_entity.dart';

class CutiKuotaModel extends CutiKuotaEntity {
  const CutiKuotaModel({
    required super.userId,
    required super.totalKuotaPerTahun,
    required super.kuotaTerpakai,
    required super.kuotaSisa,
    required super.tahun,
    required super.lastUpdated,
  });

  factory CutiKuotaModel.fromJson(Map<String, dynamic> json) {
    return CutiKuotaModel(
      userId: json['userId'],
      totalKuotaPerTahun: json['totalKuotaPerTahun'],
      kuotaTerpakai: json['kuotaTerpakai'],
      kuotaSisa: json['kuotaSisa'],
      tahun: json['tahun'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalKuotaPerTahun': totalKuotaPerTahun,
      'kuotaTerpakai': kuotaTerpakai,
      'kuotaSisa': kuotaSisa,
      'tahun': tahun,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory CutiKuotaModel.fromEntity(CutiKuotaEntity entity) {
    return CutiKuotaModel(
      userId: entity.userId,
      totalKuotaPerTahun: entity.totalKuotaPerTahun,
      kuotaTerpakai: entity.kuotaTerpakai,
      kuotaSisa: entity.kuotaSisa,
      tahun: entity.tahun,
      lastUpdated: entity.lastUpdated,
    );
  }

  CutiKuotaEntity toEntity() {
    return CutiKuotaEntity(
      userId: userId,
      totalKuotaPerTahun: totalKuotaPerTahun,
      kuotaTerpakai: kuotaTerpakai,
      kuotaSisa: kuotaSisa,
      tahun: tahun,
      lastUpdated: lastUpdated,
    );
  }
}
