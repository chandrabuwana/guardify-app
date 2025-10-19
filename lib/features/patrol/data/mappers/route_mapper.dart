import '../../domain/entities/patrol_route.dart';
import '../models/route_list_api_response.dart';

class RouteMapper {
  /// Convert RouteModel to PatrolRoute entity (for home page)
  static PatrolRoute toPatrolRoute(RouteModel model) {
    // Get location count - use TotalArea if Location is null
    final locationCount = model.totalArea ?? model.location ?? 0;

    // Build route name with site if available
    final routeName =
        model.site != null ? '${model.name} - ${model.site!.name}' : model.name;

    return PatrolRoute(
      id: model.id,
      name: routeName,
      description: '$locationCount Lokasi',
      locations: [], // Will be filled when user navigates to detail
      additionalLocations: const [],
      date: model.createdDate ?? DateTime.now(),
      status: PatrolRouteStatus.pending,
    );
  }

  /// Convert list of RouteModel to list of PatrolRoute
  static List<PatrolRoute> toPatrolRoutes(List<RouteModel> models) {
    return models.map((model) => toPatrolRoute(model)).toList();
  }
}
