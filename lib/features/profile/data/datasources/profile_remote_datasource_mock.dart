import 'package:injectable/injectable.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_user_model.dart';
import '../mock/profile_mock_data.dart';

/// Mock implementation untuk ProfileRemoteDataSource
/// Digunakan untuk development dan testing
@Named('mock')
@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceMock implements ProfileRemoteDataSource {
  @override
  Future<ProfileUserModel> getProfileDetails(String userId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Get mock data
    final mockProfile = ProfileMockData.getMockProfile(userId);
    return ProfileUserModel.fromEntity(mockProfile);
  }

  @override
  Future<ProfileUserModel> updateProfileDetails(ProfileUserModel profile) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 2000));
    
    // Simulate update success
    return profile;
  }

  @override
  Future<ProfileUserModel> updateName(String userId, String newName) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Get current profile and update name
    final currentProfile = ProfileMockData.getMockProfile(userId);
    final updatedProfile = currentProfile.copyWith(name: newName);
    
    return ProfileUserModel.fromEntity(updatedProfile);
  }

  @override
  Future<String> uploadProfilePhoto(String userId, String imagePath) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 3000));
    
    // Return mock image URL
    return 'https://example.com/profile/$userId.jpg';
  }

  @override
  Future<String> uploadDocument(String userId, String documentType, String filePath) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 2500));
    
    // Return mock document URL
    return 'https://example.com/documents/${documentType}_$userId.pdf';
  }

  @override
  Future<void> logout() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Simulate logout success (no action needed for mock)
  }
}