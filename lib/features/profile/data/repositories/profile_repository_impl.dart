import 'package:injectable/injectable.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../datasources/profile_local_datasource.dart';
import '../models/profile_user_model.dart';

/// Implementation repository untuk Profile
@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    @Named('mock') required this.remoteDataSource, // Using mock for now since API is not ready
    required this.localDataSource,
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
      
      // Cache data yang baru
      await localDataSource.cacheProfileData(remoteProfile);
      
      return remoteProfile.toEntity();
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
      // Logout dari remote
      await remoteDataSource.logout();
      
      // Clear semua data lokal
      await localDataSource.clearAuthToken();
      await localDataSource.clearCachedProfileData();
    } catch (e) {
      // Tetap clear data lokal meskipun remote logout gagal
      await localDataSource.clearAuthToken();
      await localDataSource.clearCachedProfileData();
      
      throw Exception('Logout berhasil, namun terjadi error: $e');
    }
  }

  @override
  Future<bool> isSessionValid() async {
    try {
      return await localDataSource.isLoggedIn();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getCurrentUserId() async {
    try {
      // TODO: Implement logic untuk mendapatkan current user ID
      // Bisa dari auth token atau cached user data
      final token = await localDataSource.getAuthToken();
      if (token != null) {
        // Parse user ID dari token atau implementasi lainnya
        return 'current_user_id'; // Replace dengan implementasi sebenarnya
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}