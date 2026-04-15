import 'package:injectable/injectable.dart';
import '../entities/incident_type_entity.dart';
import '../repositories/incident_repository.dart';

@injectable
class GetIncidentTypes {
  final IncidentRepository repository;

  GetIncidentTypes(this.repository);

  Future<List<IncidentTypeEntity>> call() {
    return repository.getIncidentTypes();
  }
}

