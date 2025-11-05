import 'package:equatable/equatable.dart';

class CutiKuotaEntity extends Equatable {
  final String userId;
  final int totalKuotaPerTahun;
  final int kuotaTerpakai;
  final int kuotaSisa;
  final int tahun;
  final DateTime lastUpdated;

  const CutiKuotaEntity({
    required this.userId,
    required this.totalKuotaPerTahun,
    required this.kuotaTerpakai,
    required this.kuotaSisa,
    required this.tahun,
    required this.lastUpdated,
  });

  CutiKuotaEntity copyWith({
    String? userId,
    int? totalKuotaPerTahun,
    int? kuotaTerpakai,
    int? kuotaSisa,
    int? tahun,
    DateTime? lastUpdated,
  }) {
    return CutiKuotaEntity(
      userId: userId ?? this.userId,
      totalKuotaPerTahun: totalKuotaPerTahun ?? this.totalKuotaPerTahun,
      kuotaTerpakai: kuotaTerpakai ?? this.kuotaTerpakai,
      kuotaSisa: kuotaSisa ?? this.kuotaSisa,
      tahun: tahun ?? this.tahun,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        totalKuotaPerTahun,
        kuotaTerpakai,
        kuotaSisa,
        tahun,
        lastUpdated,
      ];
}
