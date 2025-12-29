import '../../domain/entities/patrol_location.dart';
import '../../../schedule/domain/repositories/schedule_repository.dart';

class RouteTaskMapper {
  /// Convert RouteTask list to PatrolLocation list
  static List<PatrolLocation> toPatrolLocations(List<RouteTask> routeTasks) {
    return routeTasks.map((routeTask) => toPatrolLocation(routeTask)).toList();
  }

  /// Convert single RouteTask to PatrolLocation
  static PatrolLocation toPatrolLocation(RouteTask routeTask) {
    // Determine status based on RouteTask.status
    final status = routeTask.status.toUpperCase() == 'SELESAI' || 
                   routeTask.status.toUpperCase() == 'DONE'
        ? PatrolLocationStatus.completed
        : PatrolLocationStatus.pending;

    // Parse CheckIn time if available
    DateTime? completedAt;
    if (routeTask.checkIn != null && routeTask.checkIn!.isNotEmpty) {
      try {
        // Try to parse CheckIn as DateTime string
        completedAt = DateTime.tryParse(routeTask.checkIn!);
      } catch (e) {
        // If parsing fails, leave as null
        completedAt = null;
      }
    }

    return PatrolLocation(
      id: routeTask.idAreas,
      name: routeTask.areasName,
      description: 'Status: ${routeTask.status}',
      latitude: routeTask.latitude ?? 0.0,
      longitude: routeTask.longitude ?? 0.0,
      address: '', // RouteTask doesn't have address field
      status: status,
      completedAt: completedAt,
      proofImagePath: routeTask.fileUrl,
      notes: routeTask.filename,
      isAdditional: false,
    );
  }
}

