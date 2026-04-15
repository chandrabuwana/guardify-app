import 'package:injectable/injectable.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../datasources/profile_local_datasource.dart';
import '../models/profile_user_model.dart';
import '../../../auth/domain/repositories/auth_repository.dart' as auth;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/security_manager.dart';

/// Implementation repository untuk Profile
@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final auth.AuthRepository authRepository;

  ProfileRepositoryImpl({
    required this.remoteDataSource, // Using real API now
    required this.localDataSource,
    required this.authRepository,
  });

  @override
  Future<ProfileUser> getProfileDetails(String userId) async {
    try {
      // Coba ambil dari cache terlebih dahulu
      final cachedProfile = await localDataSource.getCachedProfileData(userId);
      
      // Jika ada cache dan masih valid, return cached data
      if (cachedProfile != null) {
        // TODO: Implement cache expiry logic if needed
        // Untuk sekarang, tetap fetch dari remote untuk data terbaru
      }

      // Fetch dari remote
      final remoteProfile = await remoteDataSource.getProfileDetails(userId);

      ProfileUser enrichedProfile = remoteProfile.toEntity();
      final supervisorId = enrichedProfile.atasan;
      final hasSupervisorId = supervisorId.isNotEmpty &&
          supervisorId != '-' &&
          supervisorId.toLowerCase() != 'null';

      if (hasSupervisorId) {
        try {
          final supervisorProfile =
              await remoteDataSource.getProfileDetails(supervisorId);
          enrichedProfile = enrichedProfile.copyWith(
            atasan: supervisorProfile.name,
          );
        } catch (e) {
          // Keep original supervisorId if resolving fails
        }
      }
      
      // Cache data yang baru
      await localDataSource.cacheProfileData(ProfileUserModel.fromEntity(enrichedProfile));
      
      return enrichedProfile;
    } catch (e) {
      // Jika remote gagal, coba ambil dari cache
      final cachedProfile = await localDataSource.getCachedProfileData(userId);
      if (cachedProfile != null) {
        return cachedProfile.toEntity();
      }
      
      throw Exception('Gagal mengambil data profil: $e');
    }
  }

  @override
  Future<ProfileUser> updateProfileDetails(ProfileUser updatedProfile) async {
    try {
      final profileModel = ProfileUserModel.fromEntity(updatedProfile);
      final updatedProfileModel = await remoteDataSource.updateProfileDetails(profileModel);
      
      // Update cache dengan data terbaru
      await localDataSource.cacheProfileData(updatedProfileModel);
      
      return updatedProfileModel.toEntity();
    } catch (e) {
      throw Exception('Gagal mengupdate profil: $e');
    }
  }

  @override
  Future<ProfileUser> updateName(String userId, String newName) async {
    try {
      final updatedProfileModel = await remoteDataSource.updateName(userId, newName);
      
      // Update cache dengan data terbaru
      await localDataSource.cacheProfileData(updatedProfileModel);
      
      return updatedProfileModel.toEntity();
    } catch (e) {
      throw Exception('Gagal mengupdate nama: $e');
    }
  }

  @override
  Future<ProfileUser> updateProfilePhoto(String userId, String imagePath) async {
    try {
      // Upload foto dan dapatkan URL
      await remoteDataSource.uploadProfilePhoto(userId, imagePath);
      
      // Get profile terbaru setelah update foto
      final updatedProfileModel = await remoteDataSource.getProfileDetails(userId);
      
      // Update cache dengan data terbaru
      await localDataSource.cacheProfileData(updatedProfileModel);
      
      return updatedProfileModel.toEntity();
    } catch (e) {
      throw Exception('Gagal mengupdate foto profil: $e');
    }
  }

  @override
  Future<String> uploadDocument(String userId, String documentType, String filePath) async {
    try {
      final documentUrl = await remoteDataSource.uploadDocument(userId, documentType, filePath);
      return documentUrl;
    } catch (e) {
      throw Exception('Gagal mengupload dokumen: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Logout dari remote profile service jika ada
      try {
        await remoteDataSource.logout();
      } catch (e) {
        // Ignore remote logout error
        print('Remote profile logout failed: $e');
      }

      // Logout menggunakan AuthRepository (akan clear token dengan key "token_guardify")
      final logoutResult = await authRepository.logout();

      if (!logoutResult.isSuccess) {
        // Tetap lanjutkan clear data lokal
        print('Auth logout failed but continuing with local cleanup');
      }

      // Clear data lokal profile
      await localDataSource.clearAuthToken();
      await localDataSource.clearCachedProfileData();
    } catch (e) {
      // Tetap clear semua data lokal meskipun terjadi error
      await localDataSource.clearAuthToken();
      await localDataSource.clearCachedProfileData();
      
      // Pastikan token guardify juga terhapus
      try {
        await SecurityManager.deleteSecurely(AppConstants.tokenKey);
        await SecurityManager.deleteSecurely(AppConstants.refreshTokenKey);
      } catch (securityError) {
        print('Failed to clear secure tokens: $securityError');
      }
      
      throw Exception('Logout berhasil, namun terjadi error: $e');
    }
  }

  @override
  Future<bool> isSessionValid() async {
    try {
      // Check apakah token guardify ada dan valid
      final hasValidToken = await authRepository.hasValidToken();
      
      if (!hasValidToken) {
        print('Token not found or invalid');
        return false;
      }
      
      // Check local login status
      final isLoggedInLocally = await localDataSource.isLoggedIn();
      
      return hasValidToken && isLoggedInLocally;
    } catch (e) {
      print('Error checking session validity: $e');
      return false;
    }
  }

  @override
  Future<String?> getCurrentUserId() async {
    try {
      // Get user ID dari secure storage
      final userId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      
      if (userId == null) {
        // User ID tidak ada, auto logout
        print('User ID not found, triggering auto logout');
        try {
          await logout();
        } catch (e) {
          print('Error during auto logout: $e');
        }
        return null;
      }
      
      return userId;
    } catch (e) {
      print('Error getting current user ID: $e');
      return null;
    }
  }
}