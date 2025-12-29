import '../entities/panic_alert.dart';
import '../entities/panic_button_history_item.dart';
import '../../data/models/incident_request_model.dart';
import '../../data/models/panic_button_list_request.dart';
import '../../data/models/panic_button_submit_request.dart';

abstract class PanicButtonRepository {
  Future<void> activatePanicButton(String userId);
  Future<PanicAlert> createPanicAlert(String userId);
  Future<List<String>> getVerificationItems();
  Future<Map<String, dynamic>> submitIncident(IncidentRequestModel request);
  Future<(List<PanicButtonHistoryItem>, int, int)> getPanicButtonHistory(
    PanicButtonListRequest request,
  );
  Future<PanicButtonHistoryItem> getPanicButtonDetail(String id);
  Future<void> submitPanicButtonVerification(PanicButtonSubmitRequest request);
}
