import '../../../../core/constants/enums.dart';

/// Entity untuk profile user dengan data BMI
class UserProfile {
  final String id;
  final String name;
  final String? profileImageUrl;
  final UserRole role;
  final double? currentWeight; // dalam kg
  final double? height; // dalam cm
  final double? currentBMI;
  final BMIStatus? currentBMIStatus;
  final DateTime? lastUpdated;
  final bool isPinned; // untuk fitur pin di role non-anggota

  const UserProfile({
    required this.id,
    required this.name,
    this.profileImageUrl,
    required this.role,
    this.currentWeight,
    this.height,
    this.currentBMI,
    this.currentBMIStatus,
    this.lastUpdated,
    this.isPinned = false,
  });

  /// Calculate BMI from weight and height
  static double? calculateBMI(double? weight, double? height) {
    if (weight == null || height == null || weight <= 0 || height <= 0) {
      return null;
    }

    // BMI = weight (kg) / height^2 (m)
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  /// Get BMI status from calculated BMI
  BMIStatus? get bmiStatus {
    if (currentBMI == null) return null;
    return BMIStatus.fromBMI(currentBMI!);
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? profileImageUrl,
    UserRole? role,
    double? currentWeight,
    double? height,
    double? currentBMI,
    BMIStatus? currentBMIStatus,
    DateTime? lastUpdated,
    bool? isPinned,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      currentWeight: currentWeight ?? this.currentWeight,
      height: height ?? this.height,
      currentBMI: currentBMI ?? this.currentBMI,
      currentBMIStatus: currentBMIStatus ?? this.currentBMIStatus,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.name == name &&
        other.profileImageUrl == profileImageUrl &&
        other.role == role &&
        other.currentWeight == currentWeight &&
        other.height == height &&
        other.currentBMI == currentBMI &&
        other.currentBMIStatus == currentBMIStatus &&
        other.lastUpdated == lastUpdated &&
        other.isPinned == isPinned;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      profileImageUrl,
      role,
      currentWeight,
      height,
      currentBMI,
      currentBMIStatus,
      lastUpdated,
      isPinned,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, role: $role, currentWeight: $currentWeight, height: $height, currentBMI: $currentBMI, currentBMIStatus: $currentBMIStatus, lastUpdated: $lastUpdated, isPinned: $isPinned)';
  }
}
