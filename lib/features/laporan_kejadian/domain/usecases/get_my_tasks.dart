import 'package:injectable/injectable.dart';
import '../entities/incident_entity.dart';
import '../repositories/incident_repository.dart';

@injectable
class GetMyTasks {
  final IncidentRepository repository;

  GetMyTasks(this.repository);

  Future<List<IncidentEntity>> call({
    int start = 0,
    int length = 10,
    String? searchQuery,
    IncidentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getMyTasks(
      start: start,
      length: length,
      searchQuery: searchQuery,
      status: status,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

