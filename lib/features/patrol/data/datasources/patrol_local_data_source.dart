import '../models/patrol_route_model.dart';

abstract class PatrolLocalDataSource {
  Future<List<PatrolRouteModel>> getCachedPatrolRoutes();
  Future<void> cachePatrolRoutes(List<PatrolRouteModel> routes);
  Future<void> clearCache();
}