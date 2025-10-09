import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/profile_user_model.dart';
import '../models/user_api_response_model.dart';
import 'profile_remote_datasource.dart';

/// Implementation remote data source untuk Profile menggunakan Dio
@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<ProfileUserModel> getProfileDetails(String userId) async {
    try {
      // Menggunakan endpoint User API yang benar
      final response = await _dio.get('/User/get/$userId');
      
      if (response.statusCode == 200) {
        // Parse response menggunakan UserApiResponseModel
        final apiResponse = UserApiResponseModel.fromJson(response.data);
        
        if (!apiResponse.succeeded || apiResponse.data == null) {
          throw Exception(apiResponse.message);
        }
        
        // Convert dari UserApiDataModel ke ProfileUserModel
        return apiResponse.data!.toProfileUserModel();
      } else {
        throw Exception('Failed to load profile: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  @override
  Future<ProfileUserModel> updateProfileDetails(ProfileUserModel profile) async {
    try {
      final response = await _dio.put(
        '/api/v1/profile/${profile.id}',
        data: profile.toJson(),
      );
      
      if (response.statusCode == 200) {
        return ProfileUserModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update profile: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<ProfileUserModel> updateName(String userId, String newName) async {
    try {
      final response = await _dio.patch(
        '/api/v1/profile/$userId/name',
        data: {'name': newName},
      );
      
      if (response.statusCode == 200) {
        return ProfileUserModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update name: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update name: $e');
    }
  }

  @override
  Future<String> uploadProfilePhoto(String userId, String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        '/api/v1/profile/$userId/photo',
        data: formData,
      );
      
      if (response.statusCode == 200) {
        return response.data['data']['photoUrl'];
      } else {
        throw Exception('Failed to upload photo: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  @override
  Future<String> uploadDocument(String userId, String documentType, String filePath) async {
    try {
      final formData = FormData.fromMap({
        'document': await MultipartFile.fromFile(filePath),
        'type': documentType,
      });

      final response = await _dio.post(
        '/api/v1/profile/$userId/documents',
        data: formData,
      );
      
      if (response.statusCode == 200) {
        return response.data['data']['documentUrl'];
      } else {
        throw Exception('Failed to upload document: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await _dio.post('/api/v1/auth/logout');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to logout: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }
}