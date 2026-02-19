import '../../../../core/constants/enums.dart';
import '../../domain/entities/bmi_record.dart';
import '../../domain/entities/user_profile.dart';
import '../models/bmi_api_response_model.dart';

/// Mapper untuk convert API model ke domain entities
class BmiMapper {
  /// Convert UserListItemModel ke UserProfile (untuk User/list API)
  static UserProfile userListItemToUserProfile(UserListItemModel userItem) {
    return UserProfile(
      id: userItem.id,
      name: userItem.fullname,
      profileImageUrl: userItem.urlFoto,
      role: UserRole.anggota, // Default role, can be updated based on requirements
      currentWeight: null, // Will be loaded from BMI API when detail is clicked
      height: null, // Will be loaded from BMI API when detail is clicked
      currentBMI: null, // Will be loaded from BMI API when detail is clicked
      currentBMIStatus: null, // Will be loaded from BMI API when detail is clicked
      lastUpdated: null, // Will be loaded from BMI API when detail is clicked
      isPinned: false, // Will be managed locally
      recommendation: null, // Will be loaded from BMI API when detail is clicked
    );
  }

  /// Convert list of UserListItemModel to list of UserProfile
  /// Remove duplicates based on user ID
  static List<UserProfile> userListToUserProfileList(
      List<UserListItemModel> userList) {
    // Use a map to ensure unique users by ID
    final Map<String, UserProfile> uniqueUsers = {};
    
    for (var userItem in userList) {
      // Skip if user ID is empty or already exists
      if (userItem.id.isNotEmpty && !uniqueUsers.containsKey(userItem.id)) {
        uniqueUsers[userItem.id] = userListItemToUserProfile(userItem);
      }
    }
    
    return uniqueUsers.values.toList();
  }
  /// Convert BmiDataModel ke UserProfile
  /// Menggunakan kombinasi BMI Record ID dan User ID untuk unique identification
  static UserProfile toUserProfile(BmiDataModel bmiData,
      {bool useRecordId = false}) {
    final user = bmiData.user;

    // Jika useRecordId true, gunakan bmiData.id sebagai identifier
    // Ini untuk case dimana kita mau tampilkan multiple BMI records dari user yang sama
    final profileId = useRecordId ? bmiData.id : (user?.id ?? bmiData.userId);

    return UserProfile(
      id: profileId,
      name: user?.fullname ?? bmiData.fullname ?? 'Unknown',
      profileImageUrl: null, // API doesn't provide profile image
      role: UserRole
          .anggota, // Default role, can be updated based on requirements
      currentWeight: bmiData.weight,
      height: bmiData.height,
      currentBMI: bmiData.bmi,
      currentBMIStatus: bmiData.bmiStatus,
      bmiCategory: bmiData.category,
      lastUpdated: bmiData.updateDate,
      isPinned: false, // Will be managed locally
      recommendation: bmiData.recommendation, // Ambil dari API
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
  /// Tidak melakukan grouping - setiap BMI record jadi satu UserProfile entry
  /// Menggunakan BMI Record ID sebagai identifier untuk menghindari duplicate
  static List<UserProfile> toUserProfileList(List<BmiDataModel> bmiDataList) {
    print('\n🔄 BmiMapper.toUserProfileList START');
    print('   Input: ${bmiDataList.length} BMI records');

    // Convert setiap BMI record langsung ke UserProfile tanpa grouping
    // Gunakan useRecordId=true agar setiap record punya ID unik
    final profiles = <UserProfile>[];

    for (var i = 0; i < bmiDataList.length; i++) {
      final bmiData = bmiDataList[i];
      final userId = bmiData.user?.id ?? bmiData.userId;
      final userName = bmiData.user?.fullname ?? bmiData.fullname ?? 'Unknown';

      // Skip jika userId kosong
      if (userId.isEmpty) {
        print('   [$i] ⚠️ SKIPPED: $userName (Empty userId)');
        continue;
      }

      // Gunakan BMI Record ID sebagai identifier unik
      final profile = toUserProfile(bmiData, useRecordId: true);
      profiles.add(profile);

      final updateDate =
          bmiData.updateDate?.toString().substring(0, 10) ?? 'N/A';
      print(
          '   [$i] ✅ ADDED: $userName (BMI: ${bmiData.bmi.toStringAsFixed(1)}, Date: $updateDate)');
    }

    print('   Output: ${profiles.length} BMI record entries');
    print('🔄 BmiMapper.toUserProfileList END\n');

    return profiles;
  }

  /// Convert list of BmiDataModel for a single user to BMIRecord list (history)
  static List<BMIRecord> toBMIRecordList(List<BmiDataModel> bmiDataList) {
    final records = bmiDataList.map(toBMIRecord).toList();

    // Sort by date descending (newest first)
    records.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    return records;
  }
}
