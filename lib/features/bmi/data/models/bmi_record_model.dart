import '../../../../core/constants/enums.dart';
import '../../domain/entities/bmi_record.dart';

/// Data model untuk BMIRecord
class BMIRecordModel extends BMIRecord {
  const BMIRecordModel({
    required super.id,
    required super.userId,
    required super.weight,
    required super.height,
    required super.bmi,
    required super.status,
    required super.recordedAt,
    super.notes,
    super.recordedBy,
  });

  /// Convert dari JSON
  factory BMIRecordModel.fromJson(Map<String, dynamic> json) {
    return BMIRecordModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      status: BMIStatus.values.firstWhere(
        (status) => status.value == json['status'],
        orElse: () => BMIStatus.normal,
      ),
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      notes: json['notes'] as String?,
      recordedBy: json['recorded_by'] as String?,
    );
  }

  /// Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'weight': weight,
      'height': height,
      'bmi': bmi,
      'status': status.value,
      'recorded_at': recordedAt.toIso8601String(),
      'notes': notes,
      'recorded_by': recordedBy,
    };
  }

  /// Convert dari BMIRecord entity
  factory BMIRecordModel.fromEntity(BMIRecord entity) {
    return BMIRecordModel(
      id: entity.id,
      userId: entity.userId,
      weight: entity.weight,
      height: entity.height,
      bmi: entity.bmi,
      status: entity.status,
      recordedAt: entity.recordedAt,
      notes: entity.notes,
      recordedBy: entity.recordedBy,
    );
  }

  /// Convert ke BMIRecord entity
  BMIRecord toEntity() {
    return BMIRecord(
      id: id,
      userId: userId,
      weight: weight,
      height: height,
      bmi: bmi,
      status: status,
      recordedAt: recordedAt,
      notes: notes,
      recordedBy: recordedBy,
    );
  }

  @override
  BMIRecordModel copyWith({
    String? id,
    String? userId,
    double? weight,
    double? height,
    double? bmi,
    BMIStatus? status,
    DateTime? recordedAt,
    String? notes,
    String? recordedBy,
  }) {
    return BMIRecordModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      bmi: bmi ?? this.bmi,
      status: status ?? this.status,
      recordedAt: recordedAt ?? this.recordedAt,
      notes: notes ?? this.notes,
      recordedBy: recordedBy ?? this.recordedBy,
    );
  }
}
