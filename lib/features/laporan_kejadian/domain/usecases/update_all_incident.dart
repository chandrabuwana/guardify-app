import 'package:injectable/injectable.dart';
import '../repositories/incident_repository.dart';

@injectable
class UpdateAllIncident {
  final IncidentRepository repository;

  UpdateAllIncident(this.repository);

  Future<bool> call({
    required String incidentId,
    required String areasDescription,
    required String areasId,
    required int idIncidentType,
    required DateTime incidentDate,
    required String incidentTime,
    required String incidentDescription,
    required String reportId,
    String? notesAction,
    String? picId,
    required List<String> team,
    String? handlingTask,
    String? actionTakenNote,
    String? solvedAction,
    DateTime? solvedDate,
    String? evidence,
    required String status,
    Map<String, dynamic>? incidentImage,
  }) {
    return repository.updateAllIncident(
      incidentId: incidentId,
      areasDescription: areasDescription,
      areasId: areasId,
      idIncidentType: idIncidentType,
      incidentDate: incidentDate,
      incidentTime: incidentTime,
      incidentDescription: incidentDescription,
      reportId: reportId,
      notesAction: notesAction,
      picId: picId,
      team: team,
      handlingTask: handlingTask,
      actionTakenNote: actionTakenNote,
      solvedAction: solvedAction,
      solvedDate: solvedDate,
      evidence: evidence,
      status: status,
      incidentImage: incidentImage,
    );
  }
}
