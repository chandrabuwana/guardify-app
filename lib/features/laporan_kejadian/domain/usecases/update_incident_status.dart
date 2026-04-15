import 'package:injectable/injectable.dart';
import '../repositories/incident_repository.dart';

@injectable
class UpdateIncidentStatus {
  final IncidentRepository repository;

  UpdateIncidentStatus(this.repository);

  Future<bool> call({
    required String incidentId,
    required String status, // "PROGRESS" or "COMPLETED"
    String? notes,
    Map<String, dynamic>? file,
  }) async {
    return await repository.updateIncidentStatus(
      incidentId: incidentId,
      status: status,
      notes: notes,
      file: file,
    );
  }
}

