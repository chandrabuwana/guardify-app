import '../../domain/entities/cuti_kuota_item_entity.dart';

class CutiKuotaItemModel extends CutiKuotaItemEntity {
  const CutiKuotaItemModel({
    required super.quota,
    required super.remaining,
  });

  factory CutiKuotaItemModel.fromJson(Map<String, dynamic> json) {
    return CutiKuotaItemModel(
      quota: json['Quota'] as int? ?? 0,
      remaining: json['Remaining'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Quota': quota,
      'Remaining': remaining,
    };
  }

  CutiKuotaItemEntity toEntity() {
    return CutiKuotaItemEntity(
      quota: quota,
      remaining: remaining,
    );
  }
}
