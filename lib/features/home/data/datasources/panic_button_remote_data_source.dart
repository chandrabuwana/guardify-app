import '../models/panic_button_model.dart';

abstract class PanicButtonRemoteDataSource {
  Future<bool> sendPanicAlert(PanicButtonModel panicButton);
  Future<List<PanicButtonModel>> getPanicButtonHistory(String userId);
  Future<bool> verifyPanicButton(
      String panicButtonId, List<bool> verificationStates);
}

class PanicButtonRemoteDataSourceImpl implements PanicButtonRemoteDataSource {
  // This would typically use HTTP client like Dio

  @override
  Future<bool> sendPanicAlert(PanicButtonModel panicButton) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Simulate success response
    return true;
  }

  @override
  Future<List<PanicButtonModel>> getPanicButtonHistory(String userId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Return empty list for now
    return [];
  }

  @override
  Future<bool> verifyPanicButton(
      String panicButtonId, List<bool> verificationStates) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Check if all verifications are true
    return verificationStates.every((state) => state);
  }
}
