import 'package:injectable/injectable.dart';
import '../entities/profile_user.dart';
import '../repositories/profile_repository.dart';

/// Use case untuk update foto profil user
@injectable
class UpdateProfilePhotoUseCase {
  final ProfileRepository repository;

  UpdateProfilePhotoUseCase(this.repository);

  /// Execute use case untuk update foto profil
  /// 
  /// [userId] ID user yang akan diupdate foto-nya
  /// [imagePath] path file gambar yang akan diupload
  /// Returns [ProfileUser] data profil yang sudah diupdate
  /// Throws [Exception] jika terjadi error
  Future<ProfileUser> call(String userId, String imagePath) async {
    try {
      // Validasi input
      if (userId.isEmpty) {
        throw Exception('User ID tidak boleh kosong');
      }
      
      if (imagePath.isEmpty) {
        throw Exception('Path gambar tidak boleh kosong');
      }

      // Validasi format file (basic check)
      final validExtensions = ['.jpg', '.jpeg', '.png'];
      final isValidFormat = validExtensions.any((ext) => 
        imagePath.toLowerCase().endsWith(ext));
      
      if (!isValidFormat) {
        throw Exception('Format file tidak didukung. Gunakan JPG, JPEG, atau PNG');
      }

      // Update foto via repository
      final result = await repository.updateProfilePhoto(userId, imagePath);
      return result;
    } catch (e) {
      throw Exception('Gagal mengupdate foto profil: $e');
    }
  }
}