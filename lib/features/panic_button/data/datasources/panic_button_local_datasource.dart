import '../models/incident_request_model.dart';
import '../models/panic_button_list_request.dart';
import '../models/panic_button_list_response.dart';
import '../models/panic_button_detail_response.dart';
import '../models/panic_button_submit_request.dart';
import '../models/panic_button_submit_response.dart';
import '../models/panic_button_incident_type_model.dart';
import 'panic_button_datasource.dart';

// Note: This is kept for backward compatibility but should not be used in production
// Use PanicButtonRemoteDataSourceImpl instead
class PanicButtonLocalDataSource implements PanicButtonDataSource {
  @override
  Future<void> sendPanicAlert(String userId) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Here you would typically send to a real API
    // For now, we'll just simulate success
    print('Panic alert sent for user: $userId');
  }

  @override
  Future<Map<String, dynamic>> createAlert(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return {
      'id': 'alert_${DateTime.now().millisecondsSinceEpoch}',
      'userId': userId,
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'active',
      'location': 'Current Location',
      'additionalInfo': 'Emergency alert activated',
    };
  }

  @override
  Future<List<String>> getVerificationChecklist() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      'Saya berada dalam situasi darurat yang membutuhkan bantuan segera',
      'Saya telah memastikan lokasi saya aman untuk menerima bantuan',
      'Saya memahami bahwa alert ini akan dikirim ke tim keamanan',
      'Saya siap untuk dihubungi oleh tim respons darurat',
    ];
  }

  @override
  Future<Map<String, dynamic>> submitIncident(IncidentRequestModel request) async {
    // This should not be used in production - use PanicButtonRemoteDataSourceImpl instead
    throw UnimplementedError('Use PanicButtonRemoteDataSourceImpl for submitIncident');
  }

  @override
  Future<PanicButtonListResponse> getPanicButtonList(PanicButtonListRequest request) async {
    // This should not be used in production - use PanicButtonRemoteDataSourceImpl instead
    throw UnimplementedError('Use PanicButtonRemoteDataSourceImpl for getPanicButtonList');
  }

  @override
  Future<PanicButtonDetailResponse> getPanicButtonDetail(String id) async {
    // This should not be used in production - use PanicButtonRemoteDataSourceImpl instead
    throw UnimplementedError('Use PanicButtonRemoteDataSourceImpl for getPanicButtonDetail');
  }

  @override
  Future<PanicButtonSubmitResponse> submitPanicButton(PanicButtonSubmitRequest request) async {
    // This should not be used in production - use PanicButtonRemoteDataSourceImpl instead
    throw UnimplementedError('Use PanicButtonRemoteDataSourceImpl for submitPanicButton');
  }

  @override
  Future<List<PanicButtonIncidentTypeModel>> getIncidentTypes() async {
    // This should not be used in production - use PanicButtonRemoteDataSourceImpl instead
    throw UnimplementedError('Use PanicButtonRemoteDataSourceImpl for getIncidentTypes');
  }
}
