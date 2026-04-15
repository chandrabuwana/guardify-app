import '../entities/profile_user.dart';

/// Abstract repository interface untuk Profile
/// 
/// Interface ini mendefinisikan contract yang harus diimplementasikan
/// oleh data layer repository implementation
abstract class ProfileRepository {
  /// Mengambil detail profil user berdasarkan userId
  Future<ProfileUser> getProfileDetails(String userId);

  /// Update detail profil user
  Future<ProfileUser> updateProfileDetails(ProfileUser updatedProfile);

  /// Update nama user
  Future<ProfileUser> updateName(String userId, String newName);

  /// Update foto profil user
  Future<ProfileUser> updateProfilePhoto(String userId, String imagePath);

  /// Upload dokumen profil
  Future<String> uploadDocument(String userId, String documentType, String filePath);

  /// Logout user dan clear session
  Future<void> logout();

  /// Check session validity
  Future<bool> isSessionValid();

  /// Get current user ID from session
  Future<String?> getCurrentUserId();
}