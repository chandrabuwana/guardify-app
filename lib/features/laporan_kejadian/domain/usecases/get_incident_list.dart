import 'package:injectable/injectable.dart';
import '../entities/incident_entity.dart';
import '../repositories/incident_repository.dart';

@injectable
class GetIncidentList {
  final IncidentRepository repository;

  GetIncidentList(this.repository);

  Future<List<IncidentEntity>> call({
    int start = 0,
    int length = 10,
    String? searchQuery,
    IncidentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    String? picId,
    String? incidentTypeId,
    String? locationId,
  }) async {
    print('🎯 UseCase: Getting incident list - start: $start, length: $length');
    try {
      final entities = await repository.getIncidentList(
        start: start,
        length: length,
        searchQuery: searchQuery,
        status: status,
        startDate: startDate,
        endDate: endDate,
        picId: picId,
        incidentTypeId: incidentTypeId,
        locationId: locationId,
      );
      print('🎯 UseCase: Received ${entities.length} entities from repository');
      return entities;
    } catch (e, stackTrace) {
      print('❌ UseCase: Error getting incident list: $e');
      print('❌ UseCase: Stack trace: $stackTrace');
      rethrow;
    }
  }
}

