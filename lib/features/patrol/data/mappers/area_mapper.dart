import '../../domain/entities/patrol_location.dart';
import '../models/area_list_api_response.dart';

class AreaMapper {
  /// Convert AreaModel list to PatrolLocation list
  static List<PatrolLocation> toPatrolLocations(List<AreaModel> areas) {
    return areas.map((area) => toPatrolLocation(area)).toList();
  }

  /// Convert single AreaModel to PatrolLocation
  static PatrolLocation toPatrolLocation(AreaModel area) {
    return PatrolLocation(
      id: area.id,
      name: area.name ?? 'Unknown Area',
      description: area.typeArea ?? 'Area',
      latitude: area.latitude ?? 0.0,
      longitude: area.longitude ?? 0.0,
      address: '', // Area model doesn't have address field
      status: PatrolLocationStatus.pending,
    );
  }
}

