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
    final routes = _groupRouteDetails(response.list);

    print(
        '[RouteDetailMapper] Converted ${response.list.length} route details to ${routes.length} patrol routes');

    return PaginatedResponse(
      data: routes,
      totalCount: response.count,
      filteredCount: response.filtered,
      currentPage: currentPage,
      pageSize: pageSize,
      hasMore: (currentPage * pageSize) < response.filtered,
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
          .map((detail) => PatrolLocation(
                id: detail.id,
                name: detail.name,
                description: routeInfo?.site?.name ?? 'Unknown Site',
                latitude: detail.latitude,
                longitude: detail.longitude,
                address: routeInfo?.site?.description ?? '',
                status: PatrolLocationStatus.pending,
              ))
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
      name: detail.name,
      description: detail.route?.site?.name ?? 'Unknown Site',
      latitude: detail.latitude,
      longitude: detail.longitude,
      address: detail.route?.site?.description ?? '',
      status: PatrolLocationStatus.pending,
    );
  }
}
