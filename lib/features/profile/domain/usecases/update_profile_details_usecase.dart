import 'package:injectable/injectable.dart';
import '../entities/profile_user.dart';
import '../repositories/profile_repository.dart';

/// Use case untuk update detail profil user
@injectable
class UpdateProfileDetailsUseCase {
  final ProfileRepository repository;

  UpdateProfileDetailsUseCase(this.repository);

  /// Execute use case untuk update profile details
  /// 
  /// [updatedProfile] data profil yang sudah diupdate
  /// Returns [ProfileUser] data profil yang sudah diupdate
  /// Throws [Exception] jika terjadi error
  Future<ProfileUser> call(ProfileUser updatedProfile) async {
    try {
      // Validasi basic fields
      if (updatedProfile.id.isEmpty) {
        throw Exception('User ID tidak boleh kosong');
      }
      
      if (updatedProfile.name.isEmpty) {
        throw Exception('Nama tidak boleh kosong');
      }

      if (updatedProfile.nrp.isEmpty) {
        throw Exception('NRP tidak boleh kosong');
      }

      // Update profile via repository
      final result = await repository.updateProfileDetails(updatedProfile);
      return result;
    } catch (e) {
      throw Exception('Gagal mengupdate profil: $e');
    }
  }
}