import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
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
import '../models/incident_api_model.dart' hide RoleModel;
import '../models/update_all_incident_request.dart';
import '../../../bmi/data/models/bmi_api_response_model.dart' as bmi_models;
import '../../domain/entities/incident_entity.dart';
import '../../../patrol/data/models/area_list_api_response.dart';
import '../../../patrol/data/models/route_detail_api_response.dart' as patrol_models;
import 'incident_remote_datasource.dart';

import '../../../../core/utils/image_compress_util.dart';

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
    DateTime? startDate,
    DateTime? endDate,
    String? picId,
    String? incidentTypeId,
    String? locationId,
  }) async {
    try {
      final request = IncidentListRequest.initial(
        start: start,
        length: length,
        searchQuery: searchQuery,
        status: status,
        startDate: startDate,
        endDate: endDate,
        picId: picId,
        incidentTypeId: incidentTypeId,
        locationId: locationId,
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

      // Filter by IncidentDate di client (list punya IncidentDate per item)
      if (startDate != null || endDate != null) {
        final filtered = models.where((m) {
          final dt = m.tanggalInsiden;
          if (dt == null) return false;
          final dateOnly = DateTime(dt.year, dt.month, dt.day);
          if (startDate != null) {
            final startOnly = DateTime(startDate.year, startDate.month, startDate.day);
            if (dateOnly.isBefore(startOnly)) return false;
          }
          if (endDate != null) {
            final endOnly = DateTime(endDate.year, endDate.month, endDate.day);
            if (dateOnly.isAfter(endOnly)) return false;
          }
          return true;
        }).toList();
        return filtered;
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
    int length = 50,
    String? searchQuery,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final userId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found');
      }

      final request = IncidentListRequest.initial(
        start: start,
        length: length,
        searchQuery: searchQuery,
        status: status,
        teamId: userId,
      );

      final response = await _dio.post(
        '/Incident/list',
        data: request.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load my tasks: ${response.statusMessage}');
      }

      final responseData = IncidentListResponse.fromJson(response.data);

      if (!responseData.succeeded) {
        throw Exception(responseData.message.isNotEmpty
            ? responseData.message
            : 'Failed to load my tasks');
      }

      final models = responseData.list
          .map((apiModel) => apiModel.toIncidentModel())
          .toList();

      // Filter by IncidentDate di client (sama seperti incident list)
      if (startDate != null || endDate != null) {
        return models.where((m) {
          final dt = m.tanggalInsiden;
          if (dt == null) return false;
          final dateOnly = DateTime(dt.year, dt.month, dt.day);
          if (startDate != null) {
            final startOnly = DateTime(startDate.year, startDate.month, startDate.day);
            if (dateOnly.isBefore(startOnly)) return false;
          }
          if (endDate != null) {
            final endOnly = DateTime(endDate.year, endDate.month, endDate.day);
            if (dateOnly.isAfter(endOnly)) return false;
          }
          return true;
        }).toList();
      }

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

      // Determine initial status based on reporter role
      // Rules:
      // - Pelapor = Anggota/Danton -> Status = Open (menunggu)
      // - Pelapor = PJO/Deputy/Pengawas -> Status = ACKNOWLEDGE (diterima)
      String initialStatus = 'Open';
      if (roleId.isNotEmpty) {
        // Check if reporter is PJO, Deputy, or Pengawas
        // Role IDs: PJO='PJO', DPT='DPT', PGW='PGW'
        if (roleId == 'PJO' || roleId == 'DPT' || roleId == 'PGW') {
          initialStatus = 'ACKNOWLEDGE';
        }
      }

      // Process incident image if provided
      Map<String, dynamic>? incidentImage;
      if (fotoInsiden != null && fotoInsiden.isNotEmpty) {
        try {
          final imageFile = await ImageCompressUtil.ensureMax1MbIfImage(fotoInsiden);
          if (await imageFile.exists()) {
            final bytes = await imageFile.readAsBytes();
            final base64Image = base64Encode(bytes);
            final fileName = path.basename(imageFile.path);
            final extension = path.extension(fileName).toLowerCase();
            
            // Determine MIME type from extension
            String mimeType = 'image/jpeg';
            if (extension == '.png') {
              mimeType = 'image/png';
            } else if (extension == '.jpg' || extension == '.jpeg') {
              mimeType = 'image/jpeg';
            } else if (extension == '.gif') {
              mimeType = 'image/gif';
            } else if (extension == '.webp') {
              mimeType = 'image/webp';
            } else if (extension == '.bmp') {
              mimeType = 'image/bmp';
            }

            incidentImage = {
              'Filename': fileName,
              'MimeType': mimeType,
              'Base64': base64Image,
              'FileSize': bytes.length,
            };
          }
        } catch (e) {
          // Log error but don't fail the request if image processing fails
          print('Warning: Failed to process incident image: $e');
        }
      }

      // Create request
      final request = CreateIncidentRequest(
        areasDescription: detailLokasiInsiden, // Use detail location from form field
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
        solvedDate: DateTime.now(), // Wajib diisi saat add incident (API requirement)
        status: initialStatus,
        evidence: null, // Evidence is typically empty for new incidents
        token: token,
        incidentImage: incidentImage,
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
        // Determine status based on reporter role
        IncidentStatus initialStatusModel = IncidentStatus.menunggu;
        if (roleId.isNotEmpty) {
          // Check if reporter is PJO, Deputy, or Pengawas
          if (roleId == 'PJO' || roleId == 'DPT' || roleId == 'PGW') {
            initialStatusModel = IncidentStatus.diterima;
          }
        }
        
        return IncidentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          status: initialStatusModel,
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
      // Get current incident data first
      final apiModel = await getIncidentDetailApiModel(incidentId);
      
      // Get team from existing data
      List<String> team = [];
      if (apiModel.teams != null && apiModel.teams!.isNotEmpty) {
        team = apiModel.teams!
            .map((teamMember) {
              if (teamMember is Map<String, dynamic>) {
                return teamMember['UserId']?.toString() ?? '';
              }
              return '';
            })
            .where((id) => id.isNotEmpty)
            .toList();
      }

      // Use updateAllIncident method
      return await updateAllIncident(
        incidentId: incidentId,
        areasDescription: apiModel.areasDescription ?? '',
        areasId: apiModel.areasId ?? '',
        idIncidentType: apiModel.idIncidentType ?? 0,
        incidentDate: apiModel.incidentDate ?? DateTime.now(),
        incidentTime: apiModel.incidentTime ?? '00:00:00',
        incidentDescription: apiModel.incidentDescription ?? '',
        reportId: apiModel.reportId ?? '',
        notesAction: notes ?? apiModel.notesAction,
        picId: apiModel.picId,
        team: team,
        handlingTask: null,
        actionTakenNote: null,
        solvedAction: null,
        solvedDate: null,
        evidence: null,
        status: status,
        incidentImage: file,
      );
    } catch (e) {
      throw Exception('Failed to update incident status: $e');
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
      // Get current incident data to preserve team
      final apiModel = await getIncidentDetailApiModel(incidentId);
      
      // Get team from existing data
      List<String> team = [];
      if (apiModel.teams != null && apiModel.teams!.isNotEmpty) {
        team = apiModel.teams!
            .map((teamMember) {
              if (teamMember is Map<String, dynamic>) {
                return teamMember['UserId']?.toString() ?? '';
              }
              return '';
            })
            .where((id) => id.isNotEmpty)
            .toList();
      }

      // Use updateAllIncident method
      return await updateAllIncident(
        incidentId: incidentId,
        areasDescription: areasDescription,
        areasId: areasId,
        idIncidentType: idIncidentType,
        incidentDate: incidentDate,
        incidentTime: incidentTime,
        incidentDescription: incidentDescription,
        reportId: reportId,
        notesAction: notesAction,
        picId: picId,
        team: team,
        handlingTask: null,
        actionTakenNote: null,
        solvedAction: solvedAction,
        solvedDate: solvedDate,
        evidence: null,
        status: status,
        incidentImage: null,
      );
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
    String? actionTakenNote,
    String? solvedAction,
    DateTime? solvedDate,
    String? evidence,
    required String status,
    Map<String, dynamic>? incidentImage,
    String? supervisorFeedback,
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

      // Convert evidence string to EvidenceModel if provided
      EvidenceModel? evidenceModel;
      if (evidence != null && evidence.isNotEmpty) {
        // If evidence is a URL string, we can't convert it to EvidenceModel
        // Only convert if it's already a Map
        // For now, we'll skip evidence if it's a string URL
      }

      // Convert incidentImage to EvidenceModel if provided
      if (incidentImage != null) {
        evidenceModel = EvidenceModel.fromMap(incidentImage);
      }

      // Get all fields from response /incident/getall
      IncidentApiModel? apiModel;
      try {
        apiModel = await getIncidentDetailApiModel(incidentId);
      } catch (e) {
        // If error getting incident detail, continue with provided values
      }

      // Base: semua field dari detail incident/getAll, override hanya jika diisi dari form/action
      String? areasDescriptionFinal;
      String? areasIdFinal;
      int? idIncidentTypeFinal;
      DateTime? incidentDateFinal;
      String? incidentTimeFinal;
      String? incidentDescriptionFinal;
      String? reportIdFinal;
      String? picIdFinal;
      List<String> teamFinal = [];
      String? handlingTaskFinal;
      String? notesFinal;
      String? actionTakenNoteFinal;
      String? feedBackFinal;
      String? solvedActionFinal;
      DateTime? solvedDateFinal;
      String? completedBy;
      DateTime? incidentCompletionDate;
      String? verifiedBy;
      DateTime? verifiedDate;
      String? reviewedBy;
      DateTime? reviewedDate;
      String? supervisorFeedbackFinal;
      String? createByFinal;
      DateTime? createDateFinal;
      String? updateByFinal;
      DateTime? updateDateFinal;
      
      const defaultGuid = '00000000-0000-0000-0000-000000000000';
      
      if (apiModel != null) {
        areasDescriptionFinal = apiModel.areasDescription ?? (apiModel.areas != null && apiModel.areas is AreasModel ? (apiModel.areas as AreasModel).name : null) ?? '';
        areasIdFinal = apiModel.areasId ?? '';
        idIncidentTypeFinal = apiModel.idIncidentType ?? 0;
        incidentDateFinal = apiModel.incidentDate ?? DateTime.now();
        incidentTimeFinal = apiModel.incidentTime ?? '00:00:00';
        incidentDescriptionFinal = apiModel.incidentDescription ?? '';
        reportIdFinal = apiModel.reportId ?? '';
        picIdFinal = apiModel.picId;
        if (apiModel.teams != null && apiModel.teams!.isNotEmpty) {
          teamFinal = apiModel.teams!
              .map((t) {
                if (t is Map<String, dynamic>) return t['UserId']?.toString() ?? '';
                return '';
              })
              .where((id) => id.isNotEmpty)
              .toList();
        }
        // HandlingTask: dari root, fallback dari IncidentDetail (saat Tandai Selesai tanpa input)
        var ht = apiModel.handlingTask ?? '';
        if (ht.isEmpty) {
          ht = _extractHandlingTaskFromIncidentDetail(apiModel.incidentDetail) ?? apiModel.notesAction ?? '';
        }
        handlingTaskFinal = ht;
        notesFinal = apiModel.notesAction ?? '';
        actionTakenNoteFinal = _extractActionTakenNoteFromIncidentDetail(apiModel.incidentDetail);
        feedBackFinal = apiModel.feedBack ?? '';
        solvedActionFinal = apiModel.solvedAction ?? '';
        solvedDateFinal = apiModel.solvedDate;
        completedBy = apiModel.completedBy;
        incidentCompletionDate = apiModel.incidentCompletionDate;
        // CompletedBy/IncidentCompletionDate bisa di IncidentDetail jika tidak di root
        final needCompletedFromDetail = (completedBy == null || completedBy.isEmpty) || incidentCompletionDate == null;
        if (needCompletedFromDetail) {
          final fromDetail = _extractCompletedFromIncidentDetail(apiModel.incidentDetail);
          if ((completedBy == null || completedBy.isEmpty) && fromDetail.$1 != null) completedBy = fromDetail.$1;
          if (incidentCompletionDate == null && fromDetail.$2 != null) incidentCompletionDate = fromDetail.$2;
        }
        verifiedBy = apiModel.verifiedBy;
        verifiedDate = apiModel.verifiedDate;
        // ReviewedBy/ReviewedDate: dari root, fallback dari IncidentDetail (saat PJO assign, harus ada dari detail)
        var rb = apiModel.reviewedBy;
        var rd = apiModel.reviewedDate;
        if ((rb == null || rb.isEmpty || rb == defaultGuid) || rd == null) {
          final fromDetail = _extractReviewedFromIncidentDetail(apiModel.incidentDetail);
          if ((rb == null || rb.isEmpty || rb == defaultGuid) && fromDetail.$1 != null) rb = fromDetail.$1;
          if (rd == null && fromDetail.$2 != null) rd = fromDetail.$2;
        }
        reviewedBy = (rb != null && rb.isNotEmpty && rb != defaultGuid) ? rb : null;
        reviewedDate = rd;
        supervisorFeedbackFinal = apiModel.supervisorFeedback ?? '';
        createByFinal = apiModel.createBy ?? '';
        createDateFinal = apiModel.createDate;
        updateByFinal = apiModel.updateBy ?? '';
        updateDateFinal = apiModel.updateDate;
      } else {
        // apiModel null: gunakan nilai dari param (caller)
        areasDescriptionFinal = areasDescription;
        areasIdFinal = areasId;
        idIncidentTypeFinal = idIncidentType;
        incidentDateFinal = incidentDate;
        incidentTimeFinal = incidentTime;
        incidentDescriptionFinal = incidentDescription;
        reportIdFinal = reportId;
        picIdFinal = picId;
        teamFinal = team;
        handlingTaskFinal = handlingTask ?? '';
        notesFinal = notesAction ?? '';
        actionTakenNoteFinal = actionTakenNote;
        feedBackFinal = '';
        solvedActionFinal = solvedAction ?? '';
        solvedDateFinal = solvedDate;
        supervisorFeedbackFinal = supervisorFeedback ?? '';
        createByFinal = '';
        updateByFinal = '';
      }
      
      // Override: nilai dari form/action mengalahkan nilai dari detail
      // KECUALI status REVISED: hanya ubah status, semua field lain dari detail incident/getAll
      if (status != 'REVISED') {
        if (areasDescription.isNotEmpty) areasDescriptionFinal = areasDescription;
        if (areasId.isNotEmpty) areasIdFinal = areasId;
        if (idIncidentType > 0) idIncidentTypeFinal = idIncidentType;
        incidentDateFinal = incidentDate;
        if (incidentTime.isNotEmpty) incidentTimeFinal = incidentTime;
        if (incidentDescription.isNotEmpty) incidentDescriptionFinal = incidentDescription;
        if (reportId.isNotEmpty) reportIdFinal = reportId;
        if (picId != null && picId.isNotEmpty) picIdFinal = picId;
        if (team.isNotEmpty) teamFinal = team;
        if (handlingTask != null && handlingTask.isNotEmpty) handlingTaskFinal = handlingTask;
        if (notesAction != null && notesAction.isNotEmpty) notesFinal = notesAction;
        if (actionTakenNote != null && actionTakenNote.isNotEmpty) actionTakenNoteFinal = actionTakenNote;
        if (solvedAction != null && solvedAction.isNotEmpty) solvedActionFinal = solvedAction;
        if (solvedDate != null) solvedDateFinal = solvedDate;
      }
      // SupervisorFeedback: dari form jika ada, kalo tidak dari response getAll
      // KECUALI status COMPLETED (Tandai Sebagai Selesai): selalu dari detail getAll
      if (status != 'COMPLETED' && supervisorFeedback != null && supervisorFeedback.isNotEmpty) {
        supervisorFeedbackFinal = supervisorFeedback;
      }

      // Override khusus per status
      if (status == 'COMPLETED') {
        completedBy = userId.isNotEmpty ? userId : null;
        incidentCompletionDate = DateTime.now();
        if (solvedAction != null && solvedAction.isNotEmpty) solvedActionFinal = solvedAction;
        if (solvedDate != null) solvedDateFinal = solvedDate;
      } else if (status == 'VERIFIED') {
        verifiedBy = userId; // User yang verifikasi (login)
        verifiedDate = DateTime.now();
        // CompletedBy dan IncidentCompletionDate dari detail getAll (PIC yang tandai selesai), bukan dari verifier
      } else if (status == 'ACKNOWLEDGE' || status == 'INVALID') {
        reviewedBy = userId.isNotEmpty ? userId : null;
        reviewedDate = DateTime.now();
      } else if (status == 'ASSIGNED') {
        solvedDateFinal = null; // SolvedDate jangan diisi saat assign, hanya saat Tandai Sebagai Selesai
        if (apiModel != null && apiModel.roles != null && apiModel.roles!.isNotEmpty) {
          final reporterRole = apiModel.roles!.first.nama.toUpperCase();
          if (reporterRole == 'PJO' || reporterRole == 'DPT' || reporterRole == 'PJO-PJO' || reporterRole == 'DEPUTY') {
            if (reviewedBy == null || reviewedBy.isEmpty) {
              reviewedBy = reportId.isNotEmpty ? reportId : null;
              reviewedDate = DateTime.now();
            }
          }
        }
      }

      // Build request: pakai nilai final (dari detail getAll + override dari form)
      final request = UpdateAllIncidentRequest(
        id: incidentId,
        areasDescription: areasDescriptionFinal,
        areasId: areasIdFinal,
        idIncidentType: idIncidentTypeFinal,
        incidentDate: incidentDateFinal,
        incidentTime: incidentTimeFinal,
        incidentDescription: incidentDescriptionFinal,
        reportId: reportIdFinal,
        picId: picIdFinal,
        team: teamFinal.isNotEmpty ? teamFinal : team,
        handlingTask: handlingTaskFinal,
        notes: notesFinal,
        actionTakenNote: actionTakenNoteFinal,
        feedBack: feedBackFinal,
        evidence: evidenceModel,
        status: status,
        solvedAction: solvedActionFinal,
        solvedDate: solvedDateFinal,
        incidentCompletionDate: incidentCompletionDate,
        completedBy: completedBy,
        verifiedBy: verifiedBy,
        verifiedDate: verifiedDate,
        reviewedBy: reviewedBy,
        reviewedDate: reviewedDate,
        supervisorFeedback: supervisorFeedbackFinal,
        createBy: createByFinal,
        createDate: createDateFinal, // null when apiModel null
        updateBy: updateByFinal,
        updateDate: updateDateFinal, // null when apiModel null
        token: token,
      );

      // Call API using POST /Incident/updateall
      final response = await _dio.post(
        '/Incident/updateall',
        data: request.toJson(),
      );

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

  /// Extract ReviewedBy (UserId) and ReviewedDate dari IncidentDetail bila ada di nested.
  (String?, DateTime?) _extractReviewedFromIncidentDetail(dynamic incidentDetail) {
    const defaultGuid = '00000000-0000-0000-0000-000000000000';
    String? reviewedBy;
    DateTime? reviewedDate;
    List<dynamic> list = [];
    if (incidentDetail is Map<String, dynamic>) {
      list = [incidentDetail];
    } else if (incidentDetail is List) {
      list = incidentDetail;
    }
    for (final item in list) {
      if (item is! Map) continue;
      final m = Map<String, dynamic>.from(item);
      final rb = m['ReviewedBy']?.toString() ?? m['reviewedBy']?.toString();
      final rdVal = m['ReviewedDate'] ?? m['reviewedDate'];
      if (rb != null && rb.isNotEmpty && rb != defaultGuid) {
        reviewedBy = rb;
      }
      if (rdVal != null) {
        final dt = DateTime.tryParse(rdVal.toString());
        if (dt != null) reviewedDate = dt;
      }
      if (reviewedBy != null && reviewedDate != null) break;
    }
    return (reviewedBy, reviewedDate);
  }

  /// Extract HandlingTask dari IncidentDetail.
  String? _extractHandlingTaskFromIncidentDetail(dynamic incidentDetail) {
    List<dynamic> list = [];
    if (incidentDetail is Map<String, dynamic>) {
      list = [incidentDetail];
    } else if (incidentDetail is List) {
      list = incidentDetail;
    }
    for (final item in list) {
      if (item is! Map) continue;
      final m = Map<String, dynamic>.from(item);
      final v = m['HandlingTask']?.toString() ?? m['handlingTask']?.toString();
      if (v != null && v.isNotEmpty) return v;
    }
    return null;
  }

  /// Extract CompletedBy (UserId) dan IncidentCompletionDate dari IncidentDetail bila ada di nested.
  (String?, DateTime?) _extractCompletedFromIncidentDetail(dynamic incidentDetail) {
    String? completedBy;
    DateTime? incidentCompletionDate;
    List<dynamic> list = [];
    if (incidentDetail is Map<String, dynamic>) {
      list = [incidentDetail];
    } else if (incidentDetail is List) {
      list = incidentDetail;
    }
    for (final item in list) {
      if (item is! Map) continue;
      final m = Map<String, dynamic>.from(item);
      final cb = m['CompletedBy']?.toString() ?? m['completedBy']?.toString();
      final icdVal = m['IncidentCompletionDate'] ?? m['incidentCompletionDate'];
      if (cb != null && cb.isNotEmpty) {
        completedBy = cb;
      }
      if (icdVal != null) {
        final dt = DateTime.tryParse(icdVal.toString());
        if (dt != null) incidentCompletionDate = dt;
      }
      if (completedBy != null && incidentCompletionDate != null) break;
    }
    return (completedBy, incidentCompletionDate);
  }

  /// Extract ActionTakenNote dari IncidentDetail.
  String? _extractActionTakenNoteFromIncidentDetail(dynamic incidentDetail) {
    List<dynamic> list = [];
    if (incidentDetail is Map<String, dynamic>) {
      list = [incidentDetail];
    } else if (incidentDetail is List) {
      list = incidentDetail;
    }
    for (final item in list) {
      if (item is! Map) continue;
      final m = Map<String, dynamic>.from(item);
      final v = m['ActionTakenNote']?.toString() ?? m['actionTakenNote']?.toString();
      if (v != null && v.isNotEmpty) return v;
    }
    return null;
  }
}
