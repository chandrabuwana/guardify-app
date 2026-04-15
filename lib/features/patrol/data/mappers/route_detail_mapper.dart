import '../../domain/entities/patrol_route.dart';
import '../../domain/entities/patrol_location.dart';
import '../../../../core/domain/entities/paginated_response.dart';
import '../models/route_detail_api_response.dart';

class RouteDetailMapper {
  /// Convert API response to paginated list of PatrolRoutes
  static PaginatedResponse<PatrolRoute> toPaginatedPatrolRoutes(
    RouteDetailListResponse response,
    int currentPage,
    int pageSize,
  ) {
    final routeDetailList = response.list ?? [];
    final routes = _groupRouteDetails(routeDetailList);
    final totalCount = response.count ?? 0;
    final filteredCount = response.filtered ?? 0;

    print(
        '[RouteDetailMapper] Converted ${routeDetailList.length} route details to ${routes.length} patrol routes');

    return PaginatedResponse(
      data: routes,
      totalCount: totalCount,
      filteredCount: filteredCount,
      currentPage: currentPage,
      pageSize: pageSize,
      hasMore: (currentPage * pageSize) < filteredCount,
    );
  }

  /// Group route details by route ID and convert to PatrolRoute entities
  static List<PatrolRoute> _groupRouteDetails(
      List<RouteDetailModel> routeDetails) {
    if (routeDetails.isEmpty) return [];

    // Group by route ID
    final Map<String, List<RouteDetailModel>> groupedByRoute = {};

    for (final detail in routeDetails) {
      final routeId = detail.idRoute;
      if (!groupedByRoute.containsKey(routeId)) {
        groupedByRoute[routeId] = [];
      }
      groupedByRoute[routeId]!.add(detail);
    }

    // Convert each group to PatrolRoute
    return groupedByRoute.entries.map((entry) {
      final routeId = entry.key;
      final details = entry.value;

      // Get route info from first detail (should be same for all in group)
      final firstDetail = details.first;
      final routeInfo = firstDetail.route;

      // Convert each route detail to patrol location
      final locations = details
          .map((detail) {
            // Log null values for debugging
            if (detail.name == null) {
              print('[RouteDetailMapper] Warning: Null name for location ${detail.id}');
            }
            if (detail.latitude == null || detail.longitude == null) {
              print('[RouteDetailMapper] Warning: Null coordinates for location ${detail.name ?? "Unknown"} (${detail.id})');
              print('  - Latitude: ${detail.latitude}');
              print('  - Longitude: ${detail.longitude}');
            }
            
            return PatrolLocation(
              id: detail.id,
              name: detail.name ?? 'Unknown Location', // Default value if null
              description: routeInfo?.site?.name ?? 'Unknown Site',
              latitude: detail.latitude ?? 0.0, // Default to 0.0 if null
              longitude: detail.longitude ?? 0.0, // Default to 0.0 if null
              address: routeInfo?.site?.description ?? '',
              status: PatrolLocationStatus.pending,
            );
          })
          .toList();

      // Build route name with site if available
      final routeName = routeInfo?.site?.name != null
          ? '${routeInfo!.name} - ${routeInfo.site!.name}'
          : routeInfo?.name ?? 'Unknown Route';

      return PatrolRoute(
        id: routeId,
        name: routeName,
        description: '${locations.length} Lokasi',
        locations: locations,
        additionalLocations: const [],
        date: DateTime.now(),
        status: PatrolRouteStatus.pending,
      );
    }).toList();
  }

  /// Convert single RouteDetailModel to PatrolLocation
  static PatrolLocation toPatrolLocation(RouteDetailModel detail) {
    return PatrolLocation(
      id: detail.id,
      name: detail.name ?? 'Unknown Location', // Default value if null
      description: detail.route?.site?.name ?? 'Unknown Site',
      latitude: detail.latitude ?? 0.0, // Default to 0.0 if null
      longitude: detail.longitude ?? 0.0, // Default to 0.0 if null
      address: detail.route?.site?.description ?? '',
      status: PatrolLocationStatus.pending,
    );
  }
}
