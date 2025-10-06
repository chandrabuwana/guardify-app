import 'package:injectable/injectable.dart';
import '../entities/profile_user.dart';
import '../repositories/profile_repository.dart';

/// Use case untuk update nama user
@injectable
class UpdateNameUseCase {
  final ProfileRepository repository;

  UpdateNameUseCase(this.repository);

  /// Execute use case untuk update nama
  /// 
  /// [userId] ID user yang akan diupdate nama-nya
  /// [newName] nama baru
  /// Returns [ProfileUser] data profil yang sudah diupdate
  /// Throws [Exception] jika terjadi error
  Future<ProfileUser> call(String userId, String newName) async {
    try {
      // Validasi input
      if (userId.isEmpty) {
        throw Exception('User ID tidak boleh kosong');
      }
      
      if (newName.trim().isEmpty) {
        throw Exception('Nama tidak boleh kosong');
      }

      if (newName.trim().length < 2) {
        throw Exception('Nama minimal 2 karakter');
      }

      if (newName.trim().length > 50) {
        throw Exception('Nama maksimal 50 karakter');
      }

      // Update nama via repository
      final result = await repository.updateName(userId, newName.trim());
      return result;
    } catch (e) {
      throw Exception('Gagal mengupdate nama: $e');
    }
  }
}