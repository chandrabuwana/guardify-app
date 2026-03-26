class AppConstants {
  // App Info
  static const String appName = 'Guardify App';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://api-guardify.abb-apps.com/api/v1';
  static const int connectTimeout = 60000; // Increased to 60 seconds
  static const int receiveTimeout = 60000; // Increased to 60 seconds
  
  // SignalR Configuration
  static const String signalRHubUrl = 'https://api-guardify.abb-apps.com/hubs/chat';

  // Storage Keys
  static const String tokenKey = 'token_guardify';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String userIdKey = 'user_id';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String pinKey = 'user_pin';
  static const String shiftDetailIdKey = 'shift_detail_id';
  static const String attendanceIdKey = 'attendance_id';

  // Security Configuration
  static const String encryptionKey = 'guardify_encryption_key_2024';
  static const int sessionTimeoutMinutes = 30;
  static const int maxLoginAttempts = 5;
  static const int lockoutDurationMinutes = 15;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int pinLength = 6;

  // Error Messages
  static const String genericErrorMessage =
      'Terjadi kesalahan. Silakan coba lagi.';
  static const String networkErrorMessage =
      'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
  static const String unauthorizedErrorMessage =
      'Sesi Anda telah berakhir. Silakan login kembali.';
  static const String biometricNotAvailableMessage =
      'Biometrik tidak tersedia di perangkat ini.';
}
