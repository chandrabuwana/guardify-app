import '../security/security_manager.dart';
import '../constants/enums.dart';
import '../constants/app_constants.dart';

/// Helper class untuk mengambil dan mengelola user role dari secure storage
class UserRoleHelper {
  /// Get user role ID dari secure storage
  /// Returns null jika belum ada data tersimpan
  static Future<String?> getUserRoleId() async {
    return await SecurityManager.readSecurely('user_role_id');
  }

  /// Get user role name dari secure storage
  /// Returns null jika belum ada data tersimpan
  static Future<String?> getUserRoleName() async {
    return await SecurityManager.readSecurely('user_role_name');
  }

  /// Get UserRole enum dari secure storage
  /// Returns UserRole.anggota sebagai default jika data tidak ditemukan
  static Future<UserRole> getUserRole() async {
    final roleId = await getUserRoleId();
    
    print('');
    print('👤 ========================================');
    print('👤 USER ROLE HELPER - GET USER ROLE');
    print('👤 ========================================');
    print('👤 Raw roleId from storage: "$roleId"');
    print('👤 RoleId is null: ${roleId == null}');
    print('👤 RoleId is empty: ${roleId?.isEmpty ?? true}');
    
    if (roleId == null || roleId.isEmpty) {
      print('👤 ⚠️ No role found, returning default: Anggota');
      print('👤 ========================================');
      print('');
      return UserRole.anggota;
    }
    
    final userRole = UserRole.fromValue(roleId);
    print('👤 Mapped to UserRole: ${userRole.displayName}');
    print('👤 UserRole value: ${userRole.value}');
    print('👤 Is Pengawas: ${userRole == UserRole.pengawas}');
    print('👤 ========================================');
    print('');
    
    return userRole;
  }

  /// Get username dari secure storage
  /// Returns null jika belum ada data tersimpan
  static Future<String?> getUsername() async {
    return await SecurityManager.readSecurely('user_username');
  }

  /// Get full name dari secure storage
  /// Returns null jika belum ada data tersimpan
  static Future<String?> getFullName() async {
    return await SecurityManager.readSecurely('user_fullname');
  }

  /// Get user ID dari secure storage
  /// Returns null jika belum ada data tersimpan
  static Future<String?> getUserId() async {
    return await SecurityManager.readSecurely(AppConstants.userIdKey);
  }

  /// Check apakah user sudah login (ada data user di secure storage)
  static Future<bool> isUserLoggedIn() async {
    final userId = await getUserId();
    final roleId = await getUserRoleId();
    return userId != null &&
        userId.isNotEmpty &&
        roleId != null &&
        roleId.isNotEmpty;
  }
}
