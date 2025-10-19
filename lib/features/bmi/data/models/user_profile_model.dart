import '../../../../core/constants/enums.dart';
import '../../domain/entities/user_profile.dart';

/// Data model untuk UserProfile
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.name,
    super.profileImageUrl,
    required super.role,
    super.currentWeight,
    super.height,
    super.currentBMI,
    super.currentBMIStatus,
    super.lastUpdated,
    super.isPinned,
    super.recommendation,
  });

  /// Convert dari JSON
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      role: UserRole.fromValue(json['role'] as String? ?? 'anggota'),
      currentWeight: (json['current_weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      currentBMI: (json['current_bmi'] as num?)?.toDouble(),
      currentBMIStatus: json['current_bmi_status'] != null
          ? BMIStatus.values.firstWhere(
              (status) => status.value == json['current_bmi_status'],
              orElse: () => BMIStatus.normal,
            )
          : null,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : null,
      isPinned: json['is_pinned'] as bool? ?? false,
      recommendation: json['recommendation'] as String?,
    );
  }

  /// Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_image_url': profileImageUrl,
      'role': role.value,
      'current_weight': currentWeight,
      'height': height,
      'current_bmi': currentBMI,
      'current_bmi_status': currentBMIStatus?.value,
      'last_updated': lastUpdated?.toIso8601String(),
      'is_pinned': isPinned,
      'recommendation': recommendation,
    };
  }

  /// Convert dari UserProfile entity
  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      name: entity.name,
      profileImageUrl: entity.profileImageUrl,
      role: entity.role,
      currentWeight: entity.currentWeight,
      height: entity.height,
      currentBMI: entity.currentBMI,
      currentBMIStatus: entity.currentBMIStatus,
      lastUpdated: entity.lastUpdated,
      isPinned: entity.isPinned,
      recommendation: entity.recommendation,
    );
  }

  /// Convert ke UserProfile entity
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      profileImageUrl: profileImageUrl,
      role: role,
      currentWeight: currentWeight,
      height: height,
      currentBMI: currentBMI,
      currentBMIStatus: currentBMIStatus,
      lastUpdated: lastUpdated,
      isPinned: isPinned,
      recommendation: recommendation,
    );
  }

  @override
  UserProfileModel copyWith({
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
    String? recommendation,
  }) {
    return UserProfileModel(
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
      recommendation: recommendation ?? this.recommendation,
    );
  }
}
