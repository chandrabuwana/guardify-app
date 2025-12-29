import 'package:injectable/injectable.dart';
import '../entities/incident_entity.dart';
import '../repositories/incident_repository.dart';

@injectable
class GetIncidentDetail {
  final IncidentRepository repository;

  GetIncidentDetail(this.repository);

  Future<IncidentEntity> call(String incidentId) {
    return repository.getIncidentDetail(incidentId);
  }
}

