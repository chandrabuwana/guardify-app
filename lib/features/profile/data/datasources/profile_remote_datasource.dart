import '../models/profile_user_model.dart';

/// Abstract data source untuk remote API
abstract class ProfileRemoteDataSource {
  /// Get profile details dari API
  Future<ProfileUserModel> getProfileDetails(String userId);

  /// Update profile details ke API
  Future<ProfileUserModel> updateProfileDetails(ProfileUserModel profile);

  /// Update nama user ke API
  Future<ProfileUserModel> updateName(String userId, String newName);

  /// Upload foto profil ke API
  Future<String> uploadProfilePhoto(String userId, String imagePath);

  /// Upload dokumen ke API
  Future<String> uploadDocument(String userId, String documentType, String filePath);

  /// Logout dari API
  Future<void> logout();
}