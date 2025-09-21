/// Model untuk input BMI calculation
class BMIInput {
  final double weight; // dalam kg
  final double height; // dalam cm
  final String? notes;

  const BMIInput({
    required this.weight,
    required this.height,
    this.notes,
  });

  /// Validasi input BMI
  bool get isValid {
    return weight > 0 &&
        weight <= 1000 && // batas maksimal berat 1000kg
        height > 0 &&
        height <= 300; // batas maksimal tinggi 300cm
  }

  /// Calculate BMI from input
  double get bmi {
    if (!isValid) throw ArgumentError('Invalid BMI input values');

    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  /// Format berat badan untuk display
  String get formattedWeight => '${weight.toStringAsFixed(1)} KG';

  /// Format tinggi badan untuk display
  String get formattedHeight => '${height.toStringAsFixed(0)} CM';

  /// Format BMI untuk display
  String get formattedBMI => '${bmi.toStringAsFixed(1)} Kg/M2';

  BMIInput copyWith({
    double? weight,
    double? height,
    String? notes,
  }) {
    return BMIInput(
      weight: weight ?? this.weight,
      height: height ?? this.height,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BMIInput &&
        other.weight == weight &&
        other.height == height &&
        other.notes == notes;
  }

  @override
  int get hashCode => Object.hash(weight, height, notes);

  @override
  String toString() {
    return 'BMIInput(weight: $weight, height: $height, notes: $notes)';
  }
}
