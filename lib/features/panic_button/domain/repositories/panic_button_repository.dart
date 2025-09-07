import '../entities/panic_alert.dart';

abstract class PanicButtonRepository {
  Future<void> activatePanicButton(String userId);
  Future<PanicAlert> createPanicAlert(String userId);
  Future<List<String>> getVerificationItems();
}
