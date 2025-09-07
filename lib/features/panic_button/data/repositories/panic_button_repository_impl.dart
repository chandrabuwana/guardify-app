import 'package:injectable/injectable.dart';
import '../../domain/entities/panic_alert.dart';
import '../../domain/repositories/panic_button_repository.dart';
import '../datasources/panic_button_datasource.dart';

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
}
