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
      // Create request
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

      // Create request with team filter using userId
      // API will filter incidents where the user is in the team
      final request = IncidentListRequest.initial(
        start: start,
        length: length,
        searchQuery: searchQuery,
        status: status,
        teamId: userId, // Filter by team using logged-in user's ID
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

      // Convert API models to IncidentModel
      // API already filtered by team, so we just need to convert
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
          final imageFile = File(fotoInsiden);
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
        solvedDate: DateTime.now(), // Set to current date time
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

      // Determine fields based on status and action
      // For PJO/Deputy assign (ASSIGNED), all fields should be taken from response
      String? completedBy;
      DateTime? incidentCompletionDate;
      String? verifiedBy;
      DateTime? verifiedDate;
      String? reviewedBy;
      DateTime? reviewedDate;
      String? handlingTaskFromResponse;
      String? feedBackFromResponse;
      String? supervisorFeedbackFromResponse;
      DateTime? createDateFromResponse;
      
      // Get fields from response if available
      const defaultGuid = '00000000-0000-0000-0000-000000000000';
      
      if (apiModel != null) {
        createDateFromResponse = apiModel.createDate;
        handlingTaskFromResponse = apiModel.handlingTask;
        feedBackFromResponse = apiModel.feedBack;
        supervisorFeedbackFromResponse = apiModel.supervisorFeedback;
        
        // Always get all fields from response first (untuk semua status)
        // Jika reviewedBy dari response adalah default GUID, anggap sebagai null (belum diisi)
        final reviewedByFromResponse = apiModel.reviewedBy;
        if (reviewedByFromResponse != null && 
            reviewedByFromResponse.isNotEmpty && 
            reviewedByFromResponse != defaultGuid) {
          reviewedBy = reviewedByFromResponse;
        } else {
          reviewedBy = null;
        }
        reviewedDate = apiModel.reviewedDate;
        verifiedBy = apiModel.verifiedBy;
        verifiedDate = apiModel.verifiedDate;
        completedBy = apiModel.completedBy;
        incidentCompletionDate = apiModel.incidentCompletionDate;
      }
      
      // Override with new values based on status (hanya field yang perlu di-update)
      // Semua field lain tetap dari response getall
      if (status == 'COMPLETED') {
        // Saat "Tandai Sebagai Selesai" (status COMPLETED):
        // - CompletedBy diisi dengan userId (user yang login)
        // - IncidentCompletionDate diisi dengan DateTime.now()
        // Field lain (reviewedBy, reviewedDate, verifiedBy, verifiedDate, dll) tetap dari response
        completedBy = userId.isNotEmpty ? userId : null;
        incidentCompletionDate = DateTime.now();
      } else if (status == 'VERIFIED') {
        // Hanya update verifiedBy dan verifiedDate
        // Field lain (reviewedBy, reviewedDate, completedBy, dll) tetap dari response
        verifiedBy = userId;
        verifiedDate = DateTime.now();
      } else if (status == 'REVISED') {
        // Hanya update supervisorFeedback (jika ada)
        // Field lain (reviewedBy, reviewedDate, verifiedBy, verifiedDate, completedBy, dll) tetap dari response
        // Tidak ada field khusus yang di-update untuk REVISED
      } else if (status == 'ACKNOWLEDGE' || status == 'INVALID') {
        // Hanya update reviewedBy dan reviewedDate
        // Field lain (verifiedBy, verifiedDate, completedBy, dll) tetap dari response
        reviewedBy = userId.isNotEmpty ? userId : null;
        reviewedDate = DateTime.now();
      } else if (status == 'ASSIGNED') {
        // Jika pelapor adalah PJO/Deputy dan status ASSIGNED, set ReviewedBy dan ReviewedDate
        // karena status skip dari "menunggu" ke "diterima" (ACKNOWLEDGE)
        // Field lain (verifiedBy, verifiedDate, completedBy, dll) tetap dari response
        if (apiModel != null && apiModel.roles != null && apiModel.roles!.isNotEmpty) {
          // Check jika reporter role adalah PJO atau Deputy
          final reporterRole = apiModel.roles!.first.nama.toUpperCase();
          if (reporterRole == 'PJO' || reporterRole == 'DPT' || reporterRole == 'PJO-PJO' || reporterRole == 'DEPUTY') {
            // Jika ReviewedBy belum diisi, set dengan reportId (user yang pelapor)
            if (reviewedBy == null || reviewedBy.isEmpty) {
              reviewedBy = reportId.isNotEmpty ? reportId : null;
              reviewedDate = DateTime.now();
            }
          }
        }
      }
      // Untuk status lain (PROGRESS, ESCALATED, dll), semua field tetap dari response

      // Create request using UpdateAllIncidentRequest model
      final request = UpdateAllIncidentRequest(
        id: incidentId,
        areasDescription: areasDescription,
        areasId: areasId,
        idIncidentType: idIncidentType,
        incidentDate: incidentDate,
        incidentTime: incidentTime,
        incidentDescription: incidentDescription,
        reportId: reportId,
        picId: picId,
        team: team,
        handlingTask: handlingTask ?? handlingTaskFromResponse ?? '',
        notes: notesAction ?? actionTakenNote,
        feedBack: feedBackFromResponse ?? '',
        evidence: evidenceModel,
        status: status,
        solvedAction: solvedAction,
        solvedDate: solvedDate,
        incidentCompletionDate: incidentCompletionDate,
        completedBy: completedBy,
        verifiedBy: verifiedBy,
        verifiedDate: verifiedDate,
        reviewedBy: reviewedBy,
        reviewedDate: reviewedDate,
        supervisorFeedback: supervisorFeedback ?? supervisorFeedbackFromResponse ?? '',
        createDate: createDateFromResponse, // Ambil dari response /incident/getall
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
}
