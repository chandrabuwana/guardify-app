import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';
import '../models/user_profile_model.dart';
import '../models/bmi_record_model.dart';
import '../../../../core/constants/enums.dart';

/// Local data source untuk BMI data
@injectable
class BMILocalDataSource {
  final SharedPreferences sharedPreferences;

  BMILocalDataSource(this.sharedPreferences);

  static const String _pinnedUsersKey = 'pinned_users';
  static const String _bmiRecordsKey = 'bmi_records';
  static const String _userProfilesKey = 'user_profiles';

  /// Get pinned user IDs
  Future<List<String>> getPinnedUserIds() async {
    final pinnedData = sharedPreferences.getString(_pinnedUsersKey);
    if (pinnedData == null) return [];

    final List<dynamic> pinnedList = json.decode(pinnedData);
    return pinnedList.cast<String>();
  }

  /// Save pinned user IDs
  Future<void> savePinnedUserIds(List<String> userIds) async {
    await sharedPreferences.setString(_pinnedUsersKey, json.encode(userIds));
  }

  /// Toggle pin user
  Future<void> togglePinUser(String userId, bool isPinned) async {
    final pinnedIds = await getPinnedUserIds();

    if (isPinned) {
      if (!pinnedIds.contains(userId)) {
        pinnedIds.add(userId);
      }
    } else {
      pinnedIds.remove(userId);
    }

    await savePinnedUserIds(pinnedIds);
  }

  /// Get BMI records for user
  Future<List<BMIRecordModel>> getBMIRecords(String userId) async {
    final recordsData =
        sharedPreferences.getString('${_bmiRecordsKey}_$userId');
    if (recordsData == null) return [];

    final List<dynamic> recordsList = json.decode(recordsData);
    return recordsList.map((json) => BMIRecordModel.fromJson(json)).toList();
  }

  /// Save BMI record
  Future<void> saveBMIRecord(BMIRecordModel record) async {
    final existingRecords = await getBMIRecords(record.userId);

    // Remove existing record with same ID if exists
    existingRecords.removeWhere((r) => r.id == record.id);

    // Add new record
    existingRecords.add(record);

    // Sort by date descending
    existingRecords.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    // Save to local storage
    final recordsJson = existingRecords.map((r) => r.toJson()).toList();
    await sharedPreferences.setString(
      '${_bmiRecordsKey}_${record.userId}',
      json.encode(recordsJson),
    );
  }

  /// Delete BMI record
  Future<void> deleteBMIRecord(String recordId, String userId) async {
    final existingRecords = await getBMIRecords(userId);
    existingRecords.removeWhere((r) => r.id == recordId);

    final recordsJson = existingRecords.map((r) => r.toJson()).toList();
    await sharedPreferences.setString(
      '${_bmiRecordsKey}_$userId',
      json.encode(recordsJson),
    );
  }

  /// Get cached user profiles
  Future<List<UserProfileModel>> getCachedUserProfiles() async {
    final profilesData = sharedPreferences.getString(_userProfilesKey);
    if (profilesData == null) return [];

    final List<dynamic> profilesList = json.decode(profilesData);
    return profilesList.map((json) => UserProfileModel.fromJson(json)).toList();
  }

  /// Cache user profiles
  Future<void> cacheUserProfiles(List<UserProfileModel> profiles) async {
    final profilesJson = profiles.map((p) => p.toJson()).toList();
    await sharedPreferences.setString(
        _userProfilesKey, json.encode(profilesJson));
  }

  /// Get cached user profile
  Future<UserProfileModel?> getCachedUserProfile(String userId) async {
    final profiles = await getCachedUserProfiles();
    try {
      return profiles.firstWhere((p) => p.id == userId);
    } catch (e) {
      return null;
    }
  }

  /// Update cached user profile
  Future<void> updateCachedUserProfile(UserProfileModel profile) async {
    final profiles = await getCachedUserProfiles();
    final index = profiles.indexWhere((p) => p.id == profile.id);

    if (index != -1) {
      profiles[index] = profile;
    } else {
      profiles.add(profile);
    }

    await cacheUserProfiles(profiles);
  }

  /// Generate mock data for development
  Future<void> generateMockData() async {
    // Generate mock user profiles
    final mockProfiles = [
      UserProfileModel(
        id: '1',
        name: 'Aiman Hafiz',
        profileImageUrl: 'https://example.com/avatar1.jpg',
        role: UserRole.anggota,
        currentWeight: 69.0,
        height: 175.0,
        currentBMI: 24.1,
        currentBMIStatus: BMIStatus.normal,
        lastUpdated: DateTime(2025, 9, 12), // 12/09/2025 seperti di gambar
        isPinned: false,
      ),
      UserProfileModel(
        id: '2',
        name: 'John Doe',
        profileImageUrl: 'https://example.com/avatar2.jpg',
        role: UserRole.danton,
        currentWeight: 75.0,
        height: 180.0,
        currentBMI: 23.1,
        currentBMIStatus: BMIStatus.normal,
        lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
        isPinned: false,
      ),
      UserProfileModel(
        id: '3',
        name: 'Jane Smith',
        profileImageUrl: 'https://example.com/avatar3.jpg',
        role: UserRole.pjo,
        currentWeight: 60.0,
        height: 165.0,
        currentBMI: 22.0,
        currentBMIStatus: BMIStatus.normal,
        lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
        isPinned: false,
      ),
      UserProfileModel(
        id: '4',
        name: 'Bob Wilson',
        profileImageUrl: 'https://example.com/avatar4.jpg',
        role: UserRole.deputy,
        currentWeight: 85.0,
        height: 178.0,
        currentBMI: 26.8,
        currentBMIStatus: BMIStatus.overweight,
        lastUpdated: DateTime.now().subtract(const Duration(days: 4)),
        isPinned: false,
      ),
      UserProfileModel(
        id: '5',
        name: 'Alice Johnson',
        profileImageUrl: 'https://example.com/avatar5.jpg',
        role: UserRole.pengawas,
        currentWeight: 55.0,
        height: 160.0,
        currentBMI: 21.5,
        currentBMIStatus: BMIStatus.normal,
        lastUpdated: DateTime.now().subtract(const Duration(days: 5)),
        isPinned: false,
      ),
    ];

    await cacheUserProfiles(mockProfiles);

    // Generate mock BMI records for Aiman Hafiz yang sesuai dengan gambar
    final mockRecords = [
      BMIRecordModel(
        id: 'record_1',
        userId: '1',
        weight: 69.0,
        height: 175.0,
        bmi: 24.1,
        status: BMIStatus.normal,
        recordedAt: DateTime(2025, 9, 12), // 12/09/2025
        notes:
            'Stay healthy, keep strong, happy tummy happy me. running, tanning, swimming, Let\'s exercise :)',
      ),
      BMIRecordModel(
        id: 'record_2',
        userId: '1',
        weight: 64.0,
        height: 175.0,
        bmi: 22.3,
        status: BMIStatus.normal,
        recordedAt: DateTime(2025, 8, 12), // 12/08/2025
        notes:
            'Stay healthy, keep strong, happy tummy happy me. running, tanning, swimming, Let\'s exercise :)',
      ),
      BMIRecordModel(
        id: 'record_3',
        userId: '1',
        weight: 64.0,
        height: 175.0,
        bmi: 22.3,
        status: BMIStatus.normal,
        recordedAt: DateTime(2025, 7, 12), // Earlier record
        notes:
            'Stay healthy, keep strong, happy tummy happy me. running, tanning, swimming, Let\'s exercise :)',
      ),
    ];

    for (final record in mockRecords) {
      await saveBMIRecord(record);
    }
  }
}
