import '../../../../core/constants/enums.dart';
import '../../domain/entities/bmi_record.dart';
import '../../domain/entities/user_profile.dart';
import '../models/bmi_api_response_model.dart';

/// Mapper untuk convert API model ke domain entities
class BmiMapper {
  /// Convert BmiDataModel ke UserProfile
  static UserProfile toUserProfile(BmiDataModel bmiData) {
    final user = bmiData.user;

    return UserProfile(
      id: user?.id ?? bmiData.userId,
      name: user?.fullname ?? bmiData.fullname ?? 'Unknown',
      profileImageUrl: null, // API doesn't provide profile image
      role: UserRole
          .anggota, // Default role, can be updated based on requirements
      currentWeight: bmiData.weight,
      height: bmiData.height,
      currentBMI: bmiData.bmi,
      currentBMIStatus: bmiData.bmiStatus,
      lastUpdated: bmiData.updateDate,
      isPinned: false, // Will be managed locally
    );
  }

  /// Convert BmiDataModel ke BMIRecord
  static BMIRecord toBMIRecord(BmiDataModel bmiData) {
    return BMIRecord(
      id: bmiData.id,
      userId: bmiData.userId,
      weight: bmiData.weight,
      height: bmiData.height,
      bmi: bmiData.bmi,
      status: bmiData.bmiStatus,
      recordedAt: bmiData.updateDate ?? bmiData.createDate ?? DateTime.now(),
      notes: bmiData.recommendation,
      recordedBy: bmiData.updateBy ?? bmiData.createBy,
    );
  }

  /// Convert list of BmiDataModel to list of UserProfile
  static List<UserProfile> toUserProfileList(List<BmiDataModel> bmiDataList) {
    // Group by user ID and get the latest BMI for each user
    final Map<String, BmiDataModel> latestBmiByUser = {};

    for (final bmiData in bmiDataList) {
      final userId = bmiData.user?.id ?? bmiData.userId;
      final existing = latestBmiByUser[userId];

      if (existing == null) {
        latestBmiByUser[userId] = bmiData;
      } else {
        final existingDate = existing.updateDate ?? existing.createDate;
        final currentDate = bmiData.updateDate ?? bmiData.createDate;

        if (currentDate != null && existingDate != null) {
          if (currentDate.isAfter(existingDate)) {
            latestBmiByUser[userId] = bmiData;
          }
        }
      }
    }

    return latestBmiByUser.values.map(toUserProfile).toList();
  }

  /// Convert list of BmiDataModel for a single user to BMIRecord list (history)
  static List<BMIRecord> toBMIRecordList(List<BmiDataModel> bmiDataList) {
    final records = bmiDataList.map(toBMIRecord).toList();

    // Sort by date descending (newest first)
    records.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    return records;
  }
}
