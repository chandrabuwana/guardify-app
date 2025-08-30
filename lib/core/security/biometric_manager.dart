import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import '../error/exceptions.dart';

class BiometricManager {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  // Check if biometric authentication is available
  static Future<bool> isBiometricAvailable() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  // Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  // Authenticate using biometrics
  static Future<bool> authenticateWithBiometrics({
    required String localizedReason,
    bool biometricOnly = false,
  }) async {
    try {
      final bool isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        throw const BiometricException(
            'Biometric authentication not available');
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: true,
        ),
      );

      return didAuthenticate;
    } on PlatformException catch (e) {
      throw BiometricException(_mapPlatformException(e));
    } catch (e) {
      throw BiometricException('Authentication failed: ${e.toString()}');
    }
  }

  // Map platform exceptions to user-friendly messages
  static String _mapPlatformException(PlatformException e) {
    switch (e.code) {
      case auth_error.notAvailable:
        return 'Biometric authentication not available';
      case auth_error.notEnrolled:
        return 'No biometric credentials enrolled';
      case auth_error.lockedOut:
        return 'Too many failed attempts. Try again later';
      case auth_error.permanentlyLockedOut:
        return 'Biometric authentication permanently locked';
      case auth_error.passcodeNotSet:
        return 'Device passcode not set';
      default:
        return 'Biometric authentication failed';
    }
  }

  // Stop authentication
  static Future<bool> stopAuthentication() async {
    try {
      return await _localAuth.stopAuthentication();
    } catch (e) {
      return false;
    }
  }
}
