import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/security_manager.dart';
import '../models/incident_model.dart';
import '../models/incident_location_model.dart';
import '../models/incident_type_model.dart';
import '../models/incident_list_request.dart';
import '../models/incident_list_response.dart';
import '../models/incident_detail_response.dart';
import '../models/incident_type_list_api_response.dart';
import '../models/create_incident_request.dart';
import '../models/edit_incident_request.dart';
import '../models/incident_api_model.dart';
import '../../../bmi/data/models/bmi_api_response_model.dart' as bmi_models;
import '../../domain/entities/incident_entity.dart';
import '../../../patrol/data/models/area_list_api_response.dart';
import '../../../patrol/data/models/route_detail_api_response.dart' as patrol_models;
import 'incident_remote_datasource.dart';

@LazySingleton(as: IncidentRemoteDataSource)
class IncidentRemoteDataSourceImpl implements IncidentRemoteDataSource {
  final Dio _dio;

  IncidentRemoteDataSourceImpl(this._dio);

  @override
  Future<List<IncidentModel>> getIncidentList({
    int start = 0,
    int length = 50, // Increased from 10 to 50
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
      print('📋 DataSource: Parsing ${responseData.list.length} incidents');
      for (var i = 0; i < responseData.list.length; i++) {
        try {
          final apiModel = responseData.list[i];
          final model = apiModel.toIncidentModel();
          models.add(model);
          print('✅ DataSource: Successfully parsed incident ${i + 1}/${responseData.list.length}: ${model.id}');
        } catch (e, stackTrace) {
          // Log error but continue processing
          print('❌ DataSource: Error parsing incident ${i + 1}/${responseData.list.length}: $e');
          print('❌ DataSource: Stack trace: $stackTrace');
          // Skip invalid items but continue processing
          continue;
        }
      }
      
      print('📋 DataSource: Successfully parsed ${models.length}/${responseData.list.length} incidents');
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
    int length = 50, // Increased from 10 to 50
    String? searchQuery,
    String? status,
  }) async {
    try {
      // Get current user ID
      final userId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found');
      }

      // Create request WITHOUT PicId filter - we'll filter in client side
      // to include both PIC and team members
      final request = IncidentListRequest.initial(
        start: start,
        length: length * 2, // Get more data to account for filtering
        searchQuery: searchQuery,
        status: status,
        // Don't filter by picId here - filter in client side instead
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

      // Filter: Include incidents where:
      // 1. Status = Ditugaskan (ASSIGNED) OR Proses (PROGRESS)
      // 2. User is PIC OR is in Teams
      // IMPORTANT: Check Teams directly from API model before converting to IncidentModel
      // because incidentDetail might be empty if Teams is empty (after our recent changes)
      final filteredApiModels = responseData.list.where((apiModel) {
        // Check status: hanya tampilkan jika status ditugaskan atau proses
        final apiStatus = apiModel.status?.toUpperCase().trim() ?? '';
        final isAssignedOrInProgress = apiStatus == 'ASSIGNED' || apiStatus == 'PROGRESS';
        if (!isAssignedOrInProgress) {
          return false;
        }
        
        // Check if user is PIC
        if (apiModel.picId == userId) {
          return true;
        }
        
        // Check if user is in Teams (from API model directly)
        if (apiModel.teams != null && apiModel.teams!.isNotEmpty) {
          for (var team in apiModel.teams!) {
            if (team is Map<String, dynamic>) {
              final teamUserId = team['UserId']?.toString() ?? '';
              if (teamUserId == userId) {
                return true;
              }
            }
          }
        }
        
        // Also check from IncidentDetail (for backward compatibility)
        // This handles cases where Teams might be empty but IncidentDetail has team info
        if (apiModel.incidentDetail != null) {
          List<Map<String, dynamic>> incidentDetailList = [];
          if (apiModel.incidentDetail is Map<String, dynamic>) {
            incidentDetailList.add(Map<String, dynamic>.from(apiModel.incidentDetail as Map));
          } else if (apiModel.incidentDetail is List) {
            for (var item in apiModel.incidentDetail as List) {
              if (item is Map) {
                incidentDetailList.add(Map<String, dynamic>.from(item));
              }
            }
          }
          
          for (var detail in incidentDetailList) {
            final teamUserId = detail['UserId']?.toString() ?? '';
            if (teamUserId == userId) {
              return true;
            }
          }
        }
        
        return false;
      }).toList();

      // Convert filtered API models to IncidentModel
      final filteredModels = filteredApiModels
          .map((apiModel) => apiModel.toIncidentModel())
          .toList();

      return filteredModels;
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
      print('[IncidentRemoteDataSource] Getting incident detail for ID: $incidentId');
      
      // Call GET /Incident/getAll/{id} endpoint
      final response = await _dio.get(
        '/Incident/getAll/$incidentId',
      );

      // Check response
      if (response.statusCode != 200) {
        throw Exception('Failed to load incident detail: ${response.statusMessage}');
      }

      // Parse response
      final responseData = IncidentDetailResponse.fromJson(response.data);
      
      if (!responseData.succeeded) {
        final errorMessage = responseData.message.isNotEmpty 
            ? responseData.message 
            : responseData.description.isNotEmpty
                ? responseData.description
                : 'Failed to load incident detail';
        throw Exception(errorMessage);
      }

      if (responseData.data == null) {
        throw Exception('Incident detail data is null');
      }

      // Convert to IncidentModel
      final incidentModel = responseData.data!.toIncidentModel();
      
      print('[IncidentRemoteDataSource] Successfully loaded incident detail: ${incidentModel.id}');
      return incidentModel;
    } on DioException catch (e) {
      print('[IncidentRemoteDataSource] DioException: ${e.message}');
      print('[IncidentRemoteDataSource] Response: ${e.response?.data}');
      
      if (e.response != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic>) {
          final errorMessage = errorData['Message']?.toString() ?? 
                             errorData['message']?.toString() ??
                             errorData['Description']?.toString() ??
                             'Failed to load incident detail';
          throw Exception(errorMessage);
        }
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('[IncidentRemoteDataSource] Exception: $e');
      throw Exception('Failed to load incident detail: $e');
    }
  }

  @override
  Future<IncidentApiModel> getIncidentDetailApiModel(String incidentId) async {
    try {
      // Call GET /Incident/getAll/{id} endpoint
      final response = await _dio.get(
        '/Incident/getAll/$incidentId',
      );

      // Check response
      if (response.statusCode != 200) {
        throw Exception('Failed to load incident detail: ${response.statusMessage}');
      }

      // Parse response
      final responseData = IncidentDetailResponse.fromJson(response.data);
      
      if (!responseData.succeeded) {
        final errorMessage = responseData.message.isNotEmpty 
            ? responseData.message 
            : responseData.description.isNotEmpty
                ? responseData.description
                : 'Failed to load incident detail';
        throw Exception(errorMessage);
      }

      if (responseData.data == null) {
        throw Exception('Incident detail data is null');
      }

      return responseData.data!;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic>) {
          final errorMessage = errorData['Message']?.toString() ?? 
                             errorData['message']?.toString() ??
                             errorData['Description']?.toString() ??
                             'Failed to load incident detail';
          throw Exception(errorMessage);
        }
      }
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
    required String lokasiInsidenName,
    required String detailLokasiInsiden,
    required String tipeInsidenId,
    required String deskripsiInsiden,
    String? fotoInsiden,
    List<String>? fileUrls,
  }) async {
    try {
      // Convert tipeInsidenId from String to int
      final idIncidentType = int.tryParse(tipeInsidenId) ?? 0;
      if (idIncidentType == 0) {
        throw Exception('Invalid incident type ID');
      }

      // Format time as HH:mm:ss
      final incidentTime = '${jamInsiden.hour.toString().padLeft(2, '0')}:'
          '${jamInsiden.minute.toString().padLeft(2, '0')}:'
          '${jamInsiden.second.toString().padLeft(2, '0')}';

      // Get current user data for Token
      final userId = await SecurityManager.readSecurely(AppConstants.userIdKey) ?? '';
      final username = await SecurityManager.readSecurely('user_username') ?? '';
      final fullName = await SecurityManager.readSecurely('user_fullname') ?? '';
      final mail = await SecurityManager.readSecurely('user_mail') ?? '';
      final roleId = await SecurityManager.readSecurely('user_role_id') ?? '';
      final roleName = await SecurityManager.readSecurely('user_role_name') ?? '';

      // Create Token model
      final token = TokenModel(
        id: userId,
        role: [
          RoleModel(
            id: roleId,
            nama: roleName.isNotEmpty ? roleName : 'Anggota',
          ),
        ],
        username: username,
        fullName: fullName,
        mail: mail,
      );

      // Create request
      final request = CreateIncidentRequest(
        areasDescription: lokasiInsidenName, // Use area name instead of detail location
        areasId: lokasiInsidenId,
        idIncidentType: idIncidentType,
        incidentDate: tanggalInsiden,
        incidentTime: incidentTime,
        incidentDescription: deskripsiInsiden,
        notesAction: null,
        picId: null,
        pjId: null,
        reportId: reporterId,
        solvedAction: null,
        solvedDate: DateTime.now(), // Set to current date time
        status: 'Open',
        token: token,
      );

      // Call API
      final response = await _dio.post(
        '/Incident/add',
        data: request.toJson(),
      );

      // Check response
      if (response.statusCode != 200) {
        throw Exception('Failed to create incident: ${response.statusMessage}');
      }

      // Parse response
      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final succeeded = responseData['Succeeded'] as bool? ?? false;
        final message = responseData['Message'] as String? ?? '';
        
        if (!succeeded) {
          throw Exception(message.isNotEmpty ? message : 'Failed to create incident');
        }

        // API doesn't return incident data, so we create a minimal model
        // The actual incident will be available after refresh
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
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic>) {
          final errorMessage = errorData['Message']?.toString() ?? 
                             errorData['message']?.toString() ??
                             'Failed to create incident';
          throw Exception(errorMessage);
        }
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create incident report: $e');
    }
  }

  @override
  Future<List<IncidentLocationModel>> getIncidentLocations() async {
    try {
      // Call Areas/list API to get all areas
      final request = AreaListRequest(
        filter: [], // Empty filter to get all areas
        sort: patrol_models.SortModel(field: 'Name', type: 1), // Sort by name ascending
        start: 0,
        length: 0, // Length 0 to get all records
      );

      // Call API
      final response = await _dio.post(
        '/Areas/list',
        data: request.toJson(),
      );

      // Check response
      if (response.statusCode != 200) {
        throw Exception('Failed to load locations: ${response.statusMessage}');
      }

      // Parse response
      final responseData = AreaListResponse.fromJson(response.data);
      
      if (!responseData.succeeded) {
        throw Exception(responseData.message.isNotEmpty 
            ? responseData.message 
            : 'Failed to load locations');
      }

      // Convert AreaModel to IncidentLocationModel
      final locations = responseData.list
          .map((area) => IncidentLocationModel(
                id: area.id,
                name: area.name ?? 'Unknown',
              ))
          .toList();

      return locations;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic>) {
          final errorMessage = errorData['Message']?.toString() ?? 
                             errorData['message']?.toString() ??
                             'Failed to load locations';
          throw Exception(errorMessage);
        }
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load locations: $e');
    }
  }

  @override
  Future<List<IncidentTypeModel>> getIncidentTypes() async {
    try {
      // Call IncidentType/list API to get all incident types
      final request = IncidentTypeListRequest(
        filter: [], // Empty filter to get all types
        sort: patrol_models.SortModel(field: 'Name', type: 1), // Sort by name ascending
        start: 0,
        length: 0, // Length 0 to get all records
      );

      // Call API
      final response = await _dio.post(
        '/IncidentType/list',
        data: request.toJson(),
      );

      // Check response
      if (response.statusCode != 200) {
        throw Exception('Failed to load incident types: ${response.statusMessage}');
      }

      // Parse response
      final responseData = IncidentTypeListResponse.fromJson(response.data);
      
      if (!responseData.succeeded) {
        throw Exception(responseData.message.isNotEmpty 
            ? responseData.message 
            : 'Failed to load incident types');
      }

      // Convert IncidentTypeApiModel to IncidentTypeModel
      final types = responseData.list
          .where((type) => type.active) // Only include active types
          .map((type) => IncidentTypeModel.fromApiModel(type))
          .toList();

      return types;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic>) {
          final errorMessage = errorData['Message']?.toString() ?? 
                             errorData['message']?.toString() ??
                             'Failed to load incident types';
          throw Exception(errorMessage);
        }
      }
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

  @override
  Future<bool> editIncident({
    required String incidentId,
    required String areasDescription,
    required String areasId,
    required int idIncidentType,
    required DateTime incidentDate,
    required String incidentTime,
    required String incidentDescription,
    required String reportId,
    String? notesAction,
    String? picId,
    String? pjId,
    String? solvedAction,
    DateTime? solvedDate,
    required String status,
  }) async {
    try {
      final request = EditIncidentRequest(
        areasDescription: areasDescription,
        areasId: areasId,
        idIncidentType: idIncidentType,
        incidentDate: incidentDate,
        incidentTime: incidentTime,
        incidentDescription: incidentDescription,
        notesAction: notesAction,
        picId: picId,
        pjId: pjId,
        reportId: reportId,
        solvedAction: solvedAction,
        solvedDate: solvedDate,
        status: status,
      );

      final response = await _dio.put(
        '/Incident/edit/$incidentId',
        data: request.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to edit incident: ${response.statusMessage}');
      }

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final succeeded = responseData['Succeeded'] as bool? ?? false;
        if (!succeeded) {
          final message = responseData['Message'] as String? ?? 'Failed to edit incident';
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
                           'Failed to edit incident';
        throw Exception(errorMessage);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to edit incident: $e');
    }
  }

  @override
  Future<List<Map<String, String>>> getUserList() async {
    try {
      final request = bmi_models.UserListRequestModel(
        filter: [
          bmi_models.FilterModel(field: '', search: ''),
        ],
        sort: bmi_models.SortModel(field: '', type: 0),
        start: 0,
        length: 0, // Get all records
      );

      final response = await _dio.post(
        '/User/list',
        data: request.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get user list: ${response.statusMessage}');
      }

      final responseData = bmi_models.UserListResponseModel.fromJson(response.data);
      
      if (responseData.succeeded == false) {
        throw Exception(responseData.message ?? 'Failed to get user list');
      }

      // Convert to list of maps with id and name
      return responseData.list.map((user) => {
        'id': user.id,
        'name': user.fullname,
      }).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        final errorMessage = errorData['Message'] as String? ?? 
                           errorData['message'] as String? ?? 
                           'Failed to get user list';
        throw Exception(errorMessage);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get user list: $e');
    }
  }

  @override
  Future<bool> updateAllIncident({
    required String incidentId,
    required String areasDescription,
    required String areasId,
    required int idIncidentType,
    required DateTime incidentDate,
    required String incidentTime,
    required String incidentDescription,
    required String reportId,
    String? notesAction,
    String? picId,
    required List<String> team,
    String? handlingTask,
    String? solvedAction,
    DateTime? solvedDate,
    String? evidence,
    required String status,
    Map<String, dynamic>? incidentImage,
  }) async {
    try {
      // Get current user data for Token
      final userId = await SecurityManager.readSecurely(AppConstants.userIdKey) ?? '';
      final username = await SecurityManager.readSecurely('user_username') ?? '';
      final fullName = await SecurityManager.readSecurely('user_fullname') ?? '';
      final mail = await SecurityManager.readSecurely('user_mail') ?? '';
      final roleId = await SecurityManager.readSecurely('user_role_id') ?? '';
      final roleName = await SecurityManager.readSecurely('user_role_name') ?? '';

      // Create Token model
      final token = TokenModel(
        id: userId,
        role: [
          RoleModel(
            id: roleId,
            nama: roleName.isNotEmpty ? roleName : 'Anggota',
          ),
        ],
        username: username,
        fullName: fullName,
        mail: mail,
      );

      // Build request data - ensure all required fields are included
      final requestData = <String, dynamic>{
        'Id': incidentId,
        'AreasDescription': areasDescription,
        'AreasId': areasId,
        'IdIncidentType': idIncidentType,
        'IncidentDate': incidentDate.toIso8601String(),
        'IncidentTime': incidentTime,
        'IncidentDescription': incidentDescription,
        'ReportId': reportId,
        'Status': status,
        'Token': token.toJson(), // Add Token payload
      };

      // Add optional fields only if they have values
      if (notesAction != null && notesAction.isNotEmpty) {
        requestData['NotesAction'] = notesAction;
      }

      if (picId != null && picId.isNotEmpty) {
        requestData['PicId'] = picId;
      }

      // Team is required, ensure it's always included
      if (team.isNotEmpty) {
        requestData['Team'] = team;
      } else {
        // If team is empty, send empty array
        requestData['Team'] = <String>[];
      }

      if (handlingTask != null && handlingTask.isNotEmpty) {
        requestData['HandlingTask'] = handlingTask;
      }

      if (solvedAction != null && solvedAction.isNotEmpty) {
        requestData['SolvedAction'] = solvedAction;
      }

      if (solvedDate != null) {
        requestData['SolvedDate'] = solvedDate.toIso8601String();
      }

      if (evidence != null && evidence.isNotEmpty) {
        requestData['Evidence'] = evidence;
      }

      if (incidentImage != null) {
        requestData['IncidentImage'] = incidentImage;
      }

      // Try different endpoint patterns based on common API patterns
      // Pattern 1: POST /Incident/updateall (ID in body)
      // Pattern 2: POST /Incident/updateall/{id} (ID in path)
      // Pattern 3: PUT /Incident/updateall/{id} (ID in path, PUT method)
      Response response;
      
      // Try Pattern 1: POST without ID in path
      try {
        response = await _dio.post(
          '/Incident/updateall',
          data: requestData,
        );
        if (response.statusCode != 200) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          );
        }
      } on DioException {
        // Try Pattern 2: POST with ID in path
        try {
          response = await _dio.post(
            '/Incident/updateall/$incidentId',
            data: requestData,
          );
          if (response.statusCode != 200) {
            throw DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
            );
          }
        } on DioException {
          // Try Pattern 3: PUT with ID in path
          response = await _dio.put(
            '/Incident/updateall/$incidentId',
            data: requestData,
          );
          if (response.statusCode != 200) {
            throw DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
            );
          }
        }
      }

      if (response.statusCode != 200) {
        throw Exception('Failed to update incident: ${response.statusMessage}');
      }

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final succeeded = responseData['Succeeded'] as bool? ?? false;
        if (!succeeded) {
          final message = responseData['Message'] as String? ?? 
                        responseData['message'] as String? ??
                        responseData['Description'] as String? ??
                        'Failed to update incident';
          throw Exception(message);
        }
        return true;
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        String errorMessage = 'Failed to update incident';
        
        if (errorData is Map<String, dynamic>) {
          errorMessage = errorData['Message'] as String? ?? 
                        errorData['message'] as String? ??
                        errorData['Description'] as String? ??
                        errorData['description'] as String? ??
                        errorMessage;
        } else if (errorData is String) {
          errorMessage = errorData;
        }
        
        throw Exception(errorMessage);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update incident: $e');
    }
  }
}
