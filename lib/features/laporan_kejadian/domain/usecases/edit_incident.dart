import 'package:injectable/injectable.dart';
import '../repositories/incident_repository.dart';

@injectable
class EditIncident {
  final IncidentRepository repository;

  EditIncident(this.repository);

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
    String? pjId,
    String? solvedAction,
    DateTime? solvedDate,
    required String status,
  }) {
    return repository.editIncident(
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
      pjId: pjId,
      solvedAction: solvedAction,
      solvedDate: solvedDate,
      status: status,
    );
  }
}

