import '../models/incident_request_model.dart';
import '../models/panic_button_list_request.dart';
import '../models/panic_button_list_response.dart';
import '../models/panic_button_detail_response.dart';
import '../models/panic_button_edit_request.dart';
import '../models/panic_button_submit_request.dart';
import '../models/panic_button_submit_response.dart';
import '../models/panic_button_incident_type_model.dart';

abstract class PanicButtonDataSource {
  Future<void> sendPanicAlert(String userId);
  Future<Map<String, dynamic>> createAlert(String userId);
  Future<List<String>> getVerificationChecklist();
  Future<Map<String, dynamic>> submitIncident(IncidentRequestModel request);
  Future<PanicButtonListResponse> getPanicButtonList(PanicButtonListRequest request);
  Future<PanicButtonDetailResponse> getPanicButtonDetail(String id);
  Future<PanicButtonSubmitResponse> submitPanicButton(PanicButtonSubmitRequest request);
  Future<PanicButtonSubmitResponse> editPanicButton(String id, PanicButtonEditRequest request);
  Future<List<PanicButtonIncidentTypeModel>> getIncidentTypes();
}
