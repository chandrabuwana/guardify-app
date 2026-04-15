import '../../domain/entities/cuti_kuota_item_entity.dart';

class CutiKuotaItemModel extends CutiKuotaItemEntity {
  const CutiKuotaItemModel({
    required super.quota,
    required super.remaining,
    super.leaveRequestName,
  });

  factory CutiKuotaItemModel.fromJson(Map<String, dynamic> json) {
    return CutiKuotaItemModel(
      quota: json['Quota'] as int? ?? 0,
      remaining: json['Remaining'] as int? ?? 0,
      leaveRequestName: json['LeaveRequestName'] as String? ??
          json['LeaveName'] as String? ??
          json['Name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Quota': quota,
      'Remaining': remaining,
      'LeaveRequestName': leaveRequestName,
    };
  }

  CutiKuotaItemEntity toEntity() {
    return CutiKuotaItemEntity(
      quota: quota,
      remaining: remaining,
      leaveRequestName: leaveRequestName,
    );
  }
}
