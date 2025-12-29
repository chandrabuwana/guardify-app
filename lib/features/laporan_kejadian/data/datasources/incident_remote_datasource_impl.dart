import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/security_manager.dart';
import '../models/incident_model.dart';
import '../models/incident_location_model.dart';
import '../models/incident_type_model.dart';
import '../models/incident_list_request.dart';
import '../models/incident_list_response.dart';
import '../../domain/entities/incident_entity.dart';
import 'incident_remote_datasource.dart';

@LazySingleton(as: IncidentRemoteDataSource)
class IncidentRemoteDataSourceImpl implements IncidentRemoteDataSource {
  final Dio _dio;

  IncidentRemoteDataSourceImpl(this._dio);

  @override
  Future<List<IncidentModel>> getIncidentList({
    int start = 0,
    int length = 10,
    String? searchQuery,
    String? status,
  }) async {
    try {
      // Create request
      final request = IncidentListRequest.initial(
        start: start,
        length: length,
        searchQuery: searchQuery,
        status: status,
      );

      // Call API
      final response = await _dio.post(
        '/Incident/list',
        data: request.toJson(),
      );

      // Check response
      if (response.statusCode != 200) {
        throw Exception('Failed to load incidents: ${response.statusMessage}');
      }

      // Parse response
      final responseData = IncidentListResponse.fromJson(response.data);
      
      if (responseData.succeeded == false && responseData.message.isNotEmpty) {
        throw Exception(responseData.message);
      }

      // Convert to models
      final models = <IncidentModel>[];
      for (var apiModel in responseData.list) {
        try {
          models.add(apiModel.toIncidentModel());
        } catch (e) {
          // Skip invalid items but continue processing
          continue;
        }
      }
      
      return models;
    } on DioException catch (e) {
      print('❌ DataSource: DioException - ${e.message}');
      print('❌ DataSource: Response: ${e.response?.data}');
      if (e.response != null) {
        throw Exception(
            'API Error: ${e.response?.data['Message'] ?? e.message}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e, stackTrace) {
      print('❌ DataSource: Exception - $e');
      print('❌ DataSource: Exception type: ${e.runtimeType}');
      print('❌ DataSource: Stack trace: $stackTrace');
      throw Exception('Failed to load incidents: $e');
    }
  }

  @override
  Future<List<IncidentModel>> getMyTasks({
    int start = 0,
    int length = 10,
    String? searchQuery,
    String? status,
  }) async {
    try {
      // Get current user ID
      final userId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found');
      }

      // Create request with PicId filter
      final request = IncidentListRequest.initial(
        start: start,
        length: length,
        searchQuery: searchQuery,
        status: status,
        picId: userId,
      );

      // Call API
      final response = await _dio.post(
        '/Incident/list',
        data: request.toJson(),
      );

      // Check response
      if (response.statusCode != 200) {
        throw Exception('Failed to load my tasks: ${response.statusMessage}');
      }

      // Parse response
      final responseData = IncidentListResponse.fromJson(response.data);
      
      if (!responseData.succeeded) {
        throw Exception(responseData.message.isNotEmpty 
            ? responseData.message 
            : 'Failed to load my tasks');
      }

      // Convert to models
      final models = responseData.list
          .map((apiModel) => apiModel.toIncidentModel())
          .toList();

      return models;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'API Error: ${e.response?.data['Message'] ?? e.message}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load my tasks: $e');
    }
  }

  @override
  Future<IncidentModel> getIncidentDetail(String incidentId) async {
    try {
      // TODO: Replace with actual API endpoint when available
      throw UnimplementedError('API endpoint not implemented yet');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load incident detail: $e');
    }
  }

  @override
  Future<IncidentModel> createIncidentReport({
    required String reporterId,
    required DateTime tanggalInsiden,
    required DateTime jamInsiden,
    required String lokasiInsidenId,
    required String detailLokasiInsiden,
    required String tipeInsidenId,
    required String deskripsiInsiden,
    String? fotoInsiden,
    List<String>? fileUrls,
  }) async {
    try {
      // TODO: Replace with actual API endpoint when available
      // For now, return a mock response
      await Future.delayed(const Duration(milliseconds: 500));
      return IncidentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        status: IncidentStatus.menunggu,
        deskripsiInsiden: deskripsiInsiden,
        tanggalInsiden: tanggalInsiden,
        jamInsiden: jamInsiden,
        lokasiInsiden: detailLokasiInsiden,
        detailLokasiInsiden: detailLokasiInsiden,
        createDate: DateTime.now(),
      );
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create incident report: $e');
    }
  }

  @override
  Future<List<IncidentLocationModel>> getIncidentLocations() async {
    try {
      // TODO: Replace with actual API endpoint when available
      // For now, return mock data
      await Future.delayed(const Duration(milliseconds: 300));
      return [
        IncidentLocationModel(id: '1', name: 'Pos Merpati'),
        IncidentLocationModel(id: '2', name: 'Pos Utama'),
        IncidentLocationModel(id: '3', name: 'Pos Selatan'),
      ];
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load locations: $e');
    }
  }

  @override
  Future<List<IncidentTypeModel>> getIncidentTypes() async {
    try {
      // TODO: Replace with actual API endpoint when available
      // For now, return mock data
      await Future.delayed(const Duration(milliseconds: 300));
      return [
        IncidentTypeModel(
          id: '1',
          name: 'Keamanan',
          type: IncidentType.keamanan,
        ),
        IncidentTypeModel(
          id: '2',
          name: 'Kebakaran',
          type: IncidentType.kebakaran,
        ),
        IncidentTypeModel(
          id: '3',
          name: 'Medis',
          type: IncidentType.medis,
        ),
        IncidentTypeModel(
          id: '4',
          name: 'Lainnya',
          type: IncidentType.lainnya,
        ),
      ];
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load incident types: $e');
    }
  }

  @override
  Future<bool> updateIncidentStatus({
    required String incidentId,
    required String status,
    String? notes,
    Map<String, dynamic>? file,
  }) async {
    try {
      final requestData = <String, dynamic>{
        'Id': incidentId,
        'Status': status,
      };

      if (notes != null && notes.isNotEmpty) {
        requestData['Notes'] = notes;
      }

      if (file != null) {
        requestData['File'] = file;
      }

      final response = await _dio.post(
        '/Incident/update',
        data: requestData,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update incident: ${response.statusMessage}');
      }

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final succeeded = responseData['Succeeded'] as bool? ?? false;
        if (!succeeded) {
          final message = responseData['Message'] as String? ?? 'Failed to update incident';
          throw Exception(message);
        }
        return true;
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        final errorMessage = errorData['Message'] as String? ?? 
                           errorData['message'] as String? ?? 
                           'Failed to update incident';
        throw Exception(errorMessage);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update incident: $e');
    }
  }
}
