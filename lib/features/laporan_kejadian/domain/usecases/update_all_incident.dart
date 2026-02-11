import 'package:injectable/injectable.dart';
import '../repositories/incident_repository.dart';

@injectable
class UpdateAllIncident {
  final IncidentRepository repository;

  UpdateAllIncident(this.repository);

  Future<bool> call({
    required String incidentId,
    required String picId,
    required List<String> team,
    required String handlingTask,
    String? notes,
    String? feedback,
    String? evidence,
    required String status,
  }) {
    return repository.updateAllIncident(
      incidentId: incidentId,
      picId: picId,
      team: team,
      handlingTask: handlingTask,
      notes: notes,
      feedback: feedback,
      evidence: evidence,
      status: status,
    );
  }
}
