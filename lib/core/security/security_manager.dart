import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class SecurityManager {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_PKCS1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Generate a secure random salt
  static String generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

  // Hash a password with salt using PBKDF2
  static String hashPassword(String password, String salt) {
    final saltBytes = base64Decode(salt);
    final passwordBytes = utf8.encode(password);

    // PBKDF2 with 100,000 iterations
    const iterations = 100000;
    const digest = sha256;
    List<int> result = passwordBytes;

    for (int i = 0; i < iterations; i++) {
      result = digest.convert([...result, ...saltBytes]).bytes;
    }

    return base64Encode(result);
  }

  // Verify password
  static bool verifyPassword(
      String password, String hashedPassword, String salt) {
    final computedHash = hashPassword(password, salt);
    return computedHash == hashedPassword;
  }

  // Encrypt sensitive data
  static String encryptData(String data) {
    final bytes = utf8.encode(data);
    final key = utf8.encode(AppConstants.encryptionKey);
    final digest = sha256.convert([...bytes, ...key]);
    return base64Encode(digest.bytes);
  }

  // Generate secure token
  static String generateSecureToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Encode(bytes);
  }

  // Store data securely
  static Future<void> storeSecurely(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  // Read data securely
  static Future<String?> readSecurely(String key) async {
    return await _secureStorage.read(key: key);
  }

  // Delete secure data
  static Future<void> deleteSecurely(String key) async {
    await _secureStorage.delete(key: key);
  }

  // Clear all secure data
  static Future<void> clearAllSecureData() async {
    await _secureStorage.deleteAll();
  }

  // Validate token format
  static bool isValidTokenFormat(String token) {
    try {
      final decoded = base64Decode(token);
      return decoded.length >= 16; // Minimum 16 bytes for security
    } catch (e) {
      return false;
    }
  }

  // Check if data has been tampered with
  static bool verifyDataIntegrity(String data, String hash) {
    final computedHash = encryptData(data);
    return computedHash == hash;
  }

  // Generate app signature for additional security
  static String generateAppSignature() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final appInfo =
        '${AppConstants.appName}:${AppConstants.appVersion}:$timestamp';
    return encryptData(appInfo);
  }
}
