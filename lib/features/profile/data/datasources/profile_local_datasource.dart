import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_user_model.dart';

/// Abstract local data source untuk Profile
abstract class ProfileLocalDataSource {
  /// Cache profile data secara lokal
  Future<void> cacheProfileData(ProfileUserModel profile);

  /// Get cached profile data
  Future<ProfileUserModel?> getCachedProfileData(String userId);

  /// Clear cached profile data
  Future<void> clearCachedProfileData();

  /// Save auth token
  Future<void> saveAuthToken(String token);

  /// Get auth token
  Future<String?> getAuthToken();

  /// Clear auth token
  Future<void> clearAuthToken();

  /// Check if user is logged in
  Future<bool> isLoggedIn();
}

/// Implementation local data source menggunakan SharedPreferences
@LazySingleton(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalDataSourceImpl(this.sharedPreferences);

  static const String _cachedProfileKey = 'cached_profile_';
  static const String _authTokenKey = 'auth_token';

  @override
  Future<void> cacheProfileData(ProfileUserModel profile) async {
    try {
      final profileJson = json.encode(profile.toJson());
      await sharedPreferences.setString('${_cachedProfileKey}${profile.id}', profileJson);
    } catch (e) {
      throw Exception('Error caching profile data: $e');
    }
  }

  @override
  Future<ProfileUserModel?> getCachedProfileData(String userId) async {
    try {
      final profileJson = sharedPreferences.getString('${_cachedProfileKey}$userId');
      if (profileJson != null) {
        final profileMap = json.decode(profileJson) as Map<String, dynamic>;
        return ProfileUserModel.fromJson(profileMap);
      }
      return null;
    } catch (e) {
      // Return null jika error parsing cached data
      return null;
    }
  }

  @override
  Future<void> clearCachedProfileData() async {
    try {
      final keys = sharedPreferences.getKeys();
      final profileKeys = keys.where((key) => key.startsWith(_cachedProfileKey));
      
      for (final key in profileKeys) {
        await sharedPreferences.remove(key);
      }
    } catch (e) {
      throw Exception('Error clearing cached profile data: $e');
    }
  }

  @override
  Future<void> saveAuthToken(String token) async {
    try {
      await sharedPreferences.setString(_authTokenKey, token);
    } catch (e) {
      throw Exception('Error saving auth token: $e');
    }
  }

  @override
  Future<String?> getAuthToken() async {
    try {
      return sharedPreferences.getString(_authTokenKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearAuthToken() async {
    try {
      await sharedPreferences.remove(_authTokenKey);
    } catch (e) {
      throw Exception('Error clearing auth token: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await getAuthToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}