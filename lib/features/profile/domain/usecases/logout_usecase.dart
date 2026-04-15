import 'package:injectable/injectable.dart';
import '../repositories/profile_repository.dart';

/// Use case untuk logout user
@injectable
class LogoutUseCase {
  final ProfileRepository repository;

  LogoutUseCase(this.repository);

  /// Execute use case untuk logout
  /// 
  /// Returns [void]
  /// Throws [Exception] jika terjadi error
  Future<void> call() async {
    try {
      // Logout via repository
      await repository.logout();
    } catch (e) {
      throw Exception('Gagal melakukan logout: $e');
    }
  }
}