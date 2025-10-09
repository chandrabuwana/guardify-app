import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/security_manager.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

/// Helper class untuk session management dan auto logout
class SessionHelper {
  final AuthRepository authRepository;

  SessionHelper({required this.authRepository});

  /// Check apakah user masih punya session valid
  /// Returns true jika session valid, false jika tidak (akan trigger auto logout)
  Future<bool> checkSession() async {
    try {
      // Check token existence
      final token = await SecurityManager.readSecurely(AppConstants.tokenKey);
      
      if (token == null || token.isEmpty) {
        print('🔒 Token tidak ditemukan, triggering auto logout');
        await _performAutoLogout();
        return false;
      }

      // Check dengan auth repository
      final hasValidToken = await authRepository.hasValidToken();
      
      if (!hasValidToken) {
        print('🔒 Token tidak valid, triggering auto logout');
        await _performAutoLogout();
        return false;
      }

      print('✅ Session valid');
      return true;
    } catch (e) {
      print('❌ Error checking session: $e');
      await _performAutoLogout();
      return false;
    }
  }

  /// Perform auto logout
  Future<void> _performAutoLogout() async {
    try {
      print('🚪 Performing auto logout...');
      
      final result = await authRepository.logout();
      
      if (result.isSuccess) {
        print('✅ Auto logout successful');
      } else {
        print('⚠️ Auto logout failed: ${result.failure?.message}');
      }
    } catch (e) {
      print('❌ Error during auto logout: $e');
      
      // Fallback: clear tokens manually
      try {
        await SecurityManager.deleteSecurely(AppConstants.tokenKey);
        await SecurityManager.deleteSecurely(AppConstants.refreshTokenKey);
        print('✅ Tokens cleared manually');
      } catch (securityError) {
        print('❌ Failed to clear tokens: $securityError');
      }
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await authRepository.isLoggedIn();
  }

  /// Get token for debugging
  Future<String?> getToken() async {
    return await SecurityManager.readSecurely(AppConstants.tokenKey);
  }
}
