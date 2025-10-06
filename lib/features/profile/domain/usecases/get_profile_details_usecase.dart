import 'package:injectable/injectable.dart';
import '../entities/profile_user.dart';
import '../repositories/profile_repository.dart';

/// Use case untuk mengambil detail profil user
@injectable
class GetProfileDetailsUseCase {
  final ProfileRepository repository;

  GetProfileDetailsUseCase(this.repository);

  /// Execute use case untuk get profile details
  /// 
  /// [userId] ID user yang akan diambil profil-nya
  /// Returns [ProfileUser] data profil user
  /// Throws [Exception] jika terjadi error
  Future<ProfileUser> call(String userId) async {
    try {
      // Validasi userId
      if (userId.isEmpty) {
        throw Exception('User ID tidak boleh kosong');
      }

      // Get profile dari repository
      final profile = await repository.getProfileDetails(userId);
      return profile;
    } catch (e) {
      throw Exception('Gagal mengambil data profil: $e');
    }
  }
}