abstract class PanicButtonDataSource {
  Future<void> sendPanicAlert(String userId);
  Future<Map<String, dynamic>> createAlert(String userId);
  Future<List<String>> getVerificationChecklist();
}
