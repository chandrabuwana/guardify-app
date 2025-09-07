import 'package:injectable/injectable.dart';
import 'panic_button_datasource.dart';

@LazySingleton(as: PanicButtonDataSource)
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
}
