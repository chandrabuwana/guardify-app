import 'package:injectable/injectable.dart';
import '../../domain/entities/panic_alert.dart';
import '../../domain/entities/panic_button_history_item.dart';
import '../../domain/repositories/panic_button_repository.dart';
import '../datasources/panic_button_datasource.dart';
import '../models/incident_request_model.dart';
import '../models/panic_button_list_request.dart';
import '../models/panic_button_edit_request.dart';
import '../models/panic_button_submit_request.dart';
import '../models/panic_button_incident_type_model.dart';
import '../mappers/panic_button_history_mapper.dart';

@LazySingleton(as: PanicButtonRepository)
class PanicButtonRepositoryImpl implements PanicButtonRepository {
  final PanicButtonDataSource dataSource;

  PanicButtonRepositoryImpl(this.dataSource);

  @override
  Future<void> activatePanicButton(String userId) async {
    try {
      await dataSource.sendPanicAlert(userId);
    } catch (e) {
      throw Exception('Failed to activate panic button: $e');
    }
  }

  @override
  Future<void> editPanicButton(String id, PanicButtonEditRequest request) async {
    try {
      print('');
      print('📦 ========================================');
      print('📦 [PanicButtonRepository] EDIT PANIC BUTTON');
      print('📦 ========================================');
      print('📦 Request Details:');
      print('  - Id: $id');
      print('  - Status: ${request.status}');

      final startTime = DateTime.now();
      final response = await dataSource.editPanicButton(id, request);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      print('📦 Response received in ${duration.inMilliseconds}ms');
      print('📦 Response Details:');
      print('  - Code: ${response.code}');
      print('  - Succeeded: ${response.succeeded}');
      print('  - Message: ${response.message}');
      print('📦 ========================================');
      print('');

      if (!response.succeeded) {
        throw Exception('API Error: ${response.message}');
      }
    } catch (e, stackTrace) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonRepository] ERROR');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ Stack Trace:');
      print(stackTrace);
      print('❌ ========================================');
      print('');
      throw Exception('Failed to edit panic button: $e');
    }
  }

  @override
  Future<PanicAlert> createPanicAlert(String userId) async {
    try {
      final alertData = await dataSource.createAlert(userId);
      return PanicAlert(
        id: alertData['id'],
        userId: alertData['userId'],
        timestamp: DateTime.parse(alertData['timestamp']),
        status: alertData['status'],
        location: alertData['location'],
        additionalInfo: alertData['additionalInfo'],
      );
    } catch (e) {
      throw Exception('Failed to create panic alert: $e');
    }
  }

  @override
  Future<List<String>> getVerificationItems() async {
    try {
      return await dataSource.getVerificationChecklist();
    } catch (e) {
      throw Exception('Failed to get verification items: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> submitIncident(IncidentRequestModel request) async {
    try {
      print('');
      print('📦 ========================================');
      print('📦 [PanicButtonRepository] SUBMIT INCIDENT');
      print('📦 ========================================');
      print('📦 Request Details:');
      print('  - AreasId: ${request.areasId}');
      print('  - ReporterId: ${request.reporterId}');
      print('  - ReporterDate: ${request.reporterDate}');
      print('  - IdIncidentType: ${request.idIncidentType}');
      print('  - Status: ${request.status}');
      print('  - Description Length: ${request.description.length}');
      print('  - Files Count: ${request.files.length}');
      
      final startTime = DateTime.now();
      final result = await dataSource.submitIncident(request);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      
      print('📦 Response received in ${duration.inMilliseconds}ms');
      print('📦 Response Data: $result');
      print('📦 ========================================');
      print('');
      
      return result;
    } catch (e, stackTrace) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonRepository] ERROR');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ Stack Trace:');
      print(stackTrace);
      print('❌ ========================================');
      print('');
      throw Exception('Failed to submit incident: $e');
    }
  }

  @override
  Future<(List<PanicButtonHistoryItem>, int, int)> getPanicButtonHistory(
    PanicButtonListRequest request,
  ) async {
    try {
      print('');
      print('📦 ========================================');
      print('📦 [PanicButtonRepository] GET PANIC BUTTON HISTORY');
      print('📦 ========================================');
      print('📦 Request Details:');
      print('  - Start: ${request.start}');
      print('  - Length: ${request.length}');
      
      final startTime = DateTime.now();
      final response = await dataSource.getPanicButtonList(request);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      
      print('📦 Response received in ${duration.inMilliseconds}ms');
      print('📦 Response Details:');
      print('  - Count: ${response.count}');
      print('  - Filtered: ${response.filtered}');
      print('  - List Count: ${response.list.length}');
      
      final historyItems = PanicButtonHistoryMapper.toHistoryItems(response.list);
      
      print('📦 Mapped to ${historyItems.length} history items');
      print('📦 ========================================');
      print('');
      
      return (historyItems, response.count, response.filtered);
    } catch (e, stackTrace) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonRepository] ERROR');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ Stack Trace:');
      print(stackTrace);
      print('❌ ========================================');
      print('');
      throw Exception('Failed to get panic button history: $e');
    }
  }

  @override
  Future<PanicButtonHistoryItem> getPanicButtonDetail(String id) async {
    try {
      print('');
      print('📦 ========================================');
      print('📦 [PanicButtonRepository] GET PANIC BUTTON DETAIL');
      print('📦 ========================================');
      print('📦 Request Details:');
      print('  - Id: $id');
      
      final startTime = DateTime.now();
      final response = await dataSource.getPanicButtonDetail(id);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      
      print('📦 Response received in ${duration.inMilliseconds}ms');
      print('📦 Response Details:');
      print('  - Code: ${response.code}');
      print('  - Succeeded: ${response.succeeded}');
      print('  - Data: ${response.data != null ? "Available" : "Null"}');
      
      if (response.data == null) {
        throw Exception('No data returned from API');
      }
      
      final historyItem = PanicButtonHistoryMapper.toHistoryItem(response.data!);
      
      print('📦 Mapped to history item: ${historyItem.id}');
      print('📦 ========================================');
      print('');
      
      return historyItem;
    } catch (e, stackTrace) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonRepository] ERROR');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ Stack Trace:');
      print(stackTrace);
      print('❌ ========================================');
      print('');
      throw Exception('Failed to get panic button detail: $e');
    }
  }

  @override
  Future<void> submitPanicButtonVerification(PanicButtonSubmitRequest request) async {
    try {
      print('');
      print('📦 ========================================');
      print('📦 [PanicButtonRepository] SUBMIT PANIC BUTTON VERIFICATION');
      print('📦 ========================================');
      print('📦 Request Details:');
      print('  - Id: ${request.id}');
      print('  - Status: ${request.status}');
      
      final startTime = DateTime.now();
      final response = await dataSource.submitPanicButton(request);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      
      print('📦 Response received in ${duration.inMilliseconds}ms');
      print('📦 Response Details:');
      print('  - Code: ${response.code}');
      print('  - Succeeded: ${response.succeeded}');
      print('  - Message: ${response.message}');
      print('📦 ========================================');
      print('');
      
      if (!response.succeeded) {
        throw Exception('API Error: ${response.message}');
      }
    } catch (e, stackTrace) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonRepository] ERROR');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ Stack Trace:');
      print(stackTrace);
      print('❌ ========================================');
      print('');
      throw Exception('Failed to submit panic button verification: $e');
    }
  }

  @override
  Future<List<PanicButtonIncidentTypeModel>> getIncidentTypes() async {
    try {
      print('');
      print('📦 ========================================');
      print('📦 [PanicButtonRepository] GET INCIDENT TYPES');
      print('📦 ========================================');

      final startTime = DateTime.now();
      final types = await dataSource.getIncidentTypes();
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      print('📦 Response received in ${duration.inMilliseconds}ms');
      print('📦 Types Count: ${types.length}');
      print('📦 ========================================');
      print('');

      return types;
    } catch (e, stackTrace) {
      print('');
      print('❌ ========================================');
      print('❌ [PanicButtonRepository] ERROR');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ Stack Trace:');
      print(stackTrace);
      print('❌ ========================================');
      print('');
      throw Exception('Failed to get incident types: $e');
    }
  }
}
