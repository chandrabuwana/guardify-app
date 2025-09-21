import '../../../../core/constants/enums.dart';

/// Entity untuk data BMI history
class BMIRecord {
  final String id;
  final String userId;
  final double weight; // dalam kg
  final double height; // dalam cm
  final double bmi;
  final BMIStatus status;
  final DateTime recordedAt;
  final String? notes; // catatan optional
  final String? recordedBy; // ID user yang input data (untuk role non-anggota)

  const BMIRecord({
    required this.id,
    required this.userId,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.status,
    required this.recordedAt,
    this.notes,
    this.recordedBy,
  });

  /// Create BMI record from weight and height
  static BMIRecord create({
    required String id,
    required String userId,
    required double weight,
    required double height,
    String? notes,
    String? recordedBy,
    DateTime? recordedAt,
  }) {
    final heightInMeters = height / 100;
    final bmi = weight / (heightInMeters * heightInMeters);
    final status = BMIStatus.fromBMI(bmi);

    return BMIRecord(
      id: id,
      userId: userId,
      weight: weight,
      height: height,
      bmi: bmi,
      status: status,
      recordedAt: recordedAt ?? DateTime.now(),
      notes: notes,
      recordedBy: recordedBy,
    );
  }

  BMIRecord copyWith({
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
    return BMIRecord(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BMIRecord &&
        other.id == id &&
        other.userId == userId &&
        other.weight == weight &&
        other.height == height &&
        other.bmi == bmi &&
        other.status == status &&
        other.recordedAt == recordedAt &&
        other.notes == notes &&
        other.recordedBy == recordedBy;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      weight,
      height,
      bmi,
      status,
      recordedAt,
      notes,
      recordedBy,
    );
  }

  @override
  String toString() {
    return 'BMIRecord(id: $id, userId: $userId, weight: $weight, height: $height, bmi: $bmi, status: $status, recordedAt: $recordedAt, notes: $notes, recordedBy: $recordedBy)';
  }
}
