import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/incident_request_model.dart';
import '../models/panic_button_list_request.dart';
import '../models/panic_button_list_response.dart';
import '../models/panic_button_detail_response.dart';
import '../models/panic_button_submit_request.dart';
import '../models/panic_button_submit_response.dart';
import '../models/panic_button_edit_request.dart';
import '../models/incident_type_list_request.dart';
import '../models/incident_type_list_response.dart';
import '../models/panic_button_incident_type_model.dart';
import '../../../patrol/data/models/route_detail_api_response.dart';
import 'panic_button_datasource.dart';
import 'panic_button_remote_data_source.dart';

@Injectable(as: PanicButtonDataSource)
class PanicButtonRemoteDataSourceImpl implements PanicButtonDataSource {
  final PanicButtonApiClient apiClient;
  final Dio dio;

  PanicButtonRemoteDataSourceImpl(this.dio) : apiClient = PanicButtonApiClient(dio);

  @override
  Future<void> sendPanicAlert(String userId) async {
    // This method might not be needed if we use submitIncident directly
    // Keeping for backward compatibility
    throw UnimplementedError('Use submitIncident instead');
  }

  @override
  Future<Map<String, dynamic>> createAlert(String userId) async {
    // This method might not be needed if we use submitIncident directly
    // Keeping for backward compatibility
    throw UnimplementedError('Use submitIncident instead');
  }

  @override
  Future<List<String>> getVerificationChecklist() async {
    // Return default verification items
    return [
      'Saya berada dalam situasi darurat yang membutuhkan bantuan segera',
      'Saya telah memastikan lokasi saya aman untuk menerima bantuan',
      'Saya memahami bahwa alert ini akan dikirim ke tim keamanan',
      'Saya siap untuk dihubungi oleh tim respons darurat',
    ];
  }

  /// Submit incident report
  Future<Map<String, dynamic>> submitIncident(IncidentRequestModel request) async {
    try {
      print('');
      print('🌐 ========================================');
      print('🌐 [PanicButtonRemoteDataSource] SUBMIT INCIDENT');
      print('🌐 ========================================');
      print('🌐 Request Details:');
      print('  - Endpoint: /PanicButton/add');
      print('  - Method: POST');
      print('  - AreasId: ${request.areasId}');
      print('  - ReporterId: ${request.reporterId}');
      print('  - ReporterDate: ${request.reporterDate}');
      print('  - IdIncidentType: ${request.idIncidentType}');
      print('  - Status: ${request.status}');
      print('  - Description: ${request.description.substring(0, request.description.length > 100 ? 100 : request.description.length)}${request.description.length > 100 ? "..." : ""}');
      print('  - Description Full Length: ${request.description.length}');
      print('  - Files Count: ${request.files.length}');
      
      // Log file details
      for (int i = 0; i < request.files.length; i++) {
        final file = request.files[i];
        print('    File[$i]:');
        print('      - Filename: ${file.filename}');
        print('      - MimeType: ${file.mimeType}');
        print('      - Base64 Length: ${file.base64.length}');
      }
      
      // Convert request to JSON
      final requestJson = request.toJson();
      print('🌐 Request JSON Size: ${requestJson.toString().length} characters');
      
      // Use Dio directly to access status code
      print('🌐 Sending request to API...');
      final startTime = DateTime.now();
      final response = await dio.post(
        '/PanicButton/add',
        data: requestJson,
      );
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      
      print('🌐 Response received in ${duration.inMilliseconds}ms');
      print('🌐 Response Details:');
      print('  - Status Code: ${response.statusCode}');
      print('  - Status Message: ${response.statusMessage}');
      print('  - Headers: ${response.headers}');
      
      // Check if status code is 200
      if (response.statusCode == 200) {
        print('✅ Status Code: 200 (Success)');
        
        // Log response data
        if (response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          print('🌐 Response Data:');
          responseData.forEach((key, value) {
            if (value is String && value.length > 100) {
              print('  - $key: ${value.substring(0, 100)}... (length: ${value.length})');
            } else {
              print('  - $key: $value');
            }
          });
          print('🌐 ========================================');
          print('✅ [PanicButtonRemoteDataSource] SUCCESS');
          print('🌐 ========================================');
          print('');
          return responseData;
        } else {
          print('🌐 Response Data Type: ${response.data.runtimeType}');
          print('🌐 Response Data: $response.data');
          print('🌐 ========================================');
          print('✅ [PanicButtonRemoteDataSource] SUCCESS');
          print('🌐 ========================================');
          print('');
          return {'success': true, 'data': response.data, 'statusCode': 200};
        }
      } else {
        print('❌ Unexpected status code: ${response.statusCode}');
        print('🌐 Response Data: ${response.data}');
        print('🌐 ========================================');
        print('❌ [PanicButtonRemoteDataSource] FAILED');
        print('🌐 ========================================');
        print('');
        throw Exception('Failed to submit incident: Status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonRemoteDataSource] DIO EXCEPTION');
      print('❌ ========================================');
      print('❌ Error Type: DioException');
      print('❌ Error Message: ${e.message}');
      print('❌ Request Path: ${e.requestOptions.path}');
      print('❌ Request Method: ${e.requestOptions.method}');
      print('❌ Request Data: ${e.requestOptions.data}');
      
      if (e.response != null) {
        print('❌ Response Status Code: ${e.response?.statusCode}');
        print('❌ Response Status Message: ${e.response?.statusMessage}');
        print('❌ Response Headers: ${e.response?.headers}');
        print('❌ Response Data: ${e.response?.data}');
        
        // If status code is not 200, throw exception
        if (e.response?.statusCode != 200) {
          print('❌ ========================================');
          print('❌ [PanicButtonRemoteDataSource] API ERROR');
          print('❌ ========================================');
          print('');
          throw Exception('API Error: Status code ${e.response?.statusCode} - ${e.response?.data}');
        }
      } else {
        print('❌ No response received (Network error)');
      }
      
      print('❌ ========================================');
      print('❌ [PanicButtonRemoteDataSource] NETWORK ERROR');
      print('❌ ========================================');
      print('');
      throw Exception('Network error: ${e.message}');
    } catch (e, stackTrace) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonRemoteDataSource] UNEXPECTED ERROR');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ Error Type: ${e.runtimeType}');
      print('❌ Stack Trace:');
      print(stackTrace);
      print('❌ ========================================');
      print('');
      throw Exception('Failed to submit incident: $e');
    }
  }

  @override
  Future<PanicButtonListResponse> getPanicButtonList(PanicButtonListRequest request) async {
    try {
      print('');
      print('🌐 ========================================');
      print('🌐 [PanicButtonRemoteDataSource] GET PANIC BUTTON LIST');
      print('🌐 ========================================');
      print('🌐 Request Details:');
      print('  - Endpoint: /PanicButton/list');
      print('  - Method: POST');
      print('  - Start: ${request.start}');
      print('  - Length: ${request.length}');
      print('  - Filter Count: ${request.filter.length}');
      print('  - Sort Field: ${request.sort.field}');
      print('  - Sort Type: ${request.sort.type}');

      final response = await apiClient.getPanicButtonList(request);

      print('🌐 Response received:');
      print('  - Count: ${response.count}');
      print('  - Filtered: ${response.filtered}');
      print('  - List Count: ${response.list.length}');
      print('  - Code: ${response.code}');
      print('  - Succeeded: ${response.succeeded}');
      print('🌐 ========================================');
      print('✅ [PanicButtonRemoteDataSource] SUCCESS');
      print('🌐 ========================================');
      print('');

      if (!response.succeeded) {
        throw Exception('API Error: ${response.message}');
      }

      return response;
    } catch (e) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonRemoteDataSource] ERROR');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ ========================================');
      print('');
      throw Exception('Failed to get panic button list: $e');
    }
  }

  @override
  Future<PanicButtonDetailResponse> getPanicButtonDetail(String id) async {
    try {
      print('');
      print('🌐 ========================================');
      print('🌐 [PanicButtonRemoteDataSource] GET PANIC BUTTON DETAIL');
      print('🌐 ========================================');
      print('🌐 Request Details:');
      print('  - Endpoint: /PanicButton/get/$id');
      print('  - Method: GET');
      print('  - Id: $id');

      final response = await apiClient.getPanicButtonDetail(id);

      print('🌐 Response received:');
      print('  - Code: ${response.code}');
      print('  - Succeeded: ${response.succeeded}');
      print('  - Message: ${response.message}');
      print('  - Data: ${response.data != null ? "Available" : "Null"}');
      print('🌐 ========================================');
      print('✅ [PanicButtonRemoteDataSource] SUCCESS');
      print('🌐 ========================================');
      print('');

      if (!response.succeeded || response.data == null) {
        throw Exception('API Error: ${response.message}');
      }

      return response;
    } catch (e) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonRemoteDataSource] ERROR');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ ========================================');
      print('');
      throw Exception('Failed to get panic button detail: $e');
    }
  }

  @override
  Future<PanicButtonSubmitResponse> submitPanicButton(PanicButtonSubmitRequest request) async {
    try {
      print('');
      print('🌐 ========================================');
      print('🌐 [PanicButtonRemoteDataSource] SUBMIT PANIC BUTTON');
      print('🌐 ========================================');
      print('🌐 Request Details:');
      print('  - Endpoint: /PanicButton/submit');
      print('  - Method: POST');
      print('  - Id: ${request.id}');
      print('  - Status: ${request.status}');
      print('  - Notes: ${request.notes ?? "null"}');

      final startTime = DateTime.now();
      final response = await apiClient.submitPanicButton(request);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      print('🌐 Response received in ${duration.inMilliseconds}ms');
      print('🌐 Response Details:');
      print('  - Code: ${response.code}');
      print('  - Succeeded: ${response.succeeded}');
      print('  - Message: ${response.message}');
      print('  - Description: ${response.description}');
      print('🌐 ========================================');
      print('✅ [PanicButtonRemoteDataSource] SUCCESS');
      print('🌐 ========================================');
      print('');

      if (!response.succeeded) {
        throw Exception('API Error: ${response.message}');
      }

      return response;
    } catch (e) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonRemoteDataSource] ERROR');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ ========================================');
      print('');
      throw Exception('Failed to submit panic button: $e');
    }
  }

  @override
  Future<PanicButtonSubmitResponse> editPanicButton(
    String id,
    PanicButtonEditRequest request,
  ) async {
    try {
      print('');
      print('🌐 ========================================');
      print('🌐 [PanicButtonRemoteDataSource] EDIT PANIC BUTTON');
      print('🌐 ========================================');
      print('🌐 Request Details:');
      print('  - Endpoint: /PanicButton/edit/$id');
      print('  - Method: PUT');
      print('  - Status: ${request.status}');
      print('  - ResolveAction: ${request.resolveAction ?? "null"}');
      print('  - EvidenceFile: ${request.evidenceFile != null ? "Available" : "Null"}');

      final startTime = DateTime.now();
      final response = await apiClient.editPanicButton(id, request.toJson());
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      print('🌐 Response received in ${duration.inMilliseconds}ms');
      print('🌐 Response Details:');
      print('  - Code: ${response.code}');
      print('  - Succeeded: ${response.succeeded}');
      print('  - Message: ${response.message}');
      print('  - Description: ${response.description}');
      print('🌐 ========================================');
      print('✅ [PanicButtonRemoteDataSource] SUCCESS');
      print('🌐 ========================================');
      print('');

      if (!response.succeeded) {
        throw Exception('API Error: ${response.message}');
      }

      return response;
    } catch (e) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonRemoteDataSource] ERROR');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ ========================================');
      print('');
      throw Exception('Failed to edit panic button: $e');
    }
  }

  @override
  Future<List<PanicButtonIncidentTypeModel>> getIncidentTypes() async {
    try {
      print('');
      print('🌐 ========================================');
      print('🌐 [PanicButtonRemoteDataSource] GET INCIDENT TYPES');
      print('🌐 ========================================');
      print('🌐 Request Details:');
      print('  - Endpoint: /IncidentType/list');
      print('  - Method: POST');

      // Create request with empty filter to get all types
      final request = IncidentTypeListRequest(
        filter: [FilterModel(field: '', search: '')],
        sort: SortModel(field: '', type: 0),
        start: 0,
        length: 0, // Length 0 to get all records
      );

      final response = await apiClient.getIncidentTypes(request);

      print('🌐 Response received:');
      print('  - Count: ${response.count}');
      print('  - Filtered: ${response.filtered}');
      print('  - List Count: ${response.list.length}');
      print('  - Code: ${response.code}');
      print('  - Succeeded: ${response.succeeded}');
      print('🌐 ========================================');
      print('✅ [PanicButtonRemoteDataSource] SUCCESS');
      print('🌐 ========================================');
      print('');

      if (!response.succeeded) {
        throw Exception('API Error: ${response.message}');
      }

      // Filter only active types
      final activeTypes = response.list
          .where((type) => type.active)
          .toList();

      print('🌐 Active types count: ${activeTypes.length}');
      return activeTypes;
    } catch (e) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonRemoteDataSource] ERROR');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ ========================================');
      print('');
      throw Exception('Failed to get incident types: $e');
    }
  }
}

