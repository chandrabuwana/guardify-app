import 'package:injectable/injectable.dart';
import '../entities/incident_location_entity.dart';
import '../repositories/incident_repository.dart';

@injectable
class GetIncidentLocations {
  final IncidentRepository repository;

  GetIncidentLocations(this.repository);

  Future<List<IncidentLocationEntity>> call() {
    return repository.getIncidentLocations();
  }
}

