import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'dart:math';
import '../models/patrol_route_model.dart';
import '../models/patrol_location_model.dart';
import '../models/patrol_attendance_model.dart';
import '../../domain/entities/patrol_location.dart';
import 'patrol_remote_data_source.dart';

@Injectable(as: PatrolRemoteDataSource)
class PatrolRemoteDataSourceImpl implements PatrolRemoteDataSource {
  final Dio dio;

  PatrolRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PatrolRouteModel>> getPatrolRoutes() async {
    try {
      // Mock data for development - replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        PatrolRouteModel(
          id: '1',
          name: 'Patroli Rute A',
          description: '4 Lokasi',
          date: DateTime.now(),
          locations: [
            const PatrolLocationModel(
              id: '1',
              name: 'Pos Macan',
              description: 'Lokasi 1',
              latitude: -6.2088,
              longitude: 106.8456,
              address: 'Jl. Sudirman No. 1',
              status: PatrolLocationStatus.pending,
            ),
            const PatrolLocationModel(
              id: '2',
              name: 'Pos Macan',
              description: 'Lokasi 2',
              latitude: -6.2089,
              longitude: 106.8457,
              address: 'Jl. Sudirman No. 2',
              status: PatrolLocationStatus.completed,
              proofImagePath: 'bukti.jpg',
            ),
            const PatrolLocationModel(
              id: '3',
              name: 'Pos Macan',
              description: 'Lokasi 3',
              latitude: -6.2090,
              longitude: 106.8458,
              address: 'Jl. Sudirman No. 3',
              status: PatrolLocationStatus.pending,
            ),
            const PatrolLocationModel(
              id: '4',
              name: 'Pos Macan',
              description: 'Lokasi 4',
              latitude: -6.2091,
              longitude: 106.8459,
              address: 'Jl. Sudirman No. 4',
              status: PatrolLocationStatus.pending,
            ),
          ],
          additionalLocations: [
            const PatrolLocationModel(
              id: 'add1',
              name: 'Patroli Tambahan',
              description: '1 Lokasi',
              latitude: -6.2092,
              longitude: 106.8460,
              address: 'Jl. Tambahan No. 1',
              status: PatrolLocationStatus.pending,
              isAdditional: true,
            ),
          ],
        ),
      ];
    } catch (e) {
      throw Exception('Failed to load patrol routes: $e');
    }
  }

  @override
  Future<PatrolRouteModel> getPatrolRouteById(String id) async {
    try {
      final routes = await getPatrolRoutes();
      return routes.firstWhere((route) => route.id == id);
    } catch (e) {
      throw Exception('Failed to load patrol route: $e');
    }
  }

  @override
  Future<Map<String, int>> getPatrolProgress(String routeId) async {
    try {
      final route = await getPatrolRouteById(routeId);
      final completed = route.locations
          .where((loc) => loc.status == PatrolLocationStatus.completed)
          .length;
      final total = route.locations.length;

      return {
        'completed': completed,
        'total': total,
      };
    } catch (e) {
      throw Exception('Failed to get patrol progress: $e');
    }
  }

  @override
  Future<bool> submitAttendance(PatrolAttendanceModel attendance) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock success response
      return true;
    } catch (e) {
      throw Exception('Failed to submit attendance: $e');
    }
  }

  @override
  Future<bool> verifyLocation(double currentLat, double currentLng, double targetLat, double targetLng) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      // Calculate distance between current and target location
      final distance = _calculateDistance(currentLat, currentLng, targetLat, targetLng);
      
      // Return true if within 100 meters
      return distance <= 100;
    } catch (e) {
      throw Exception('Failed to verify location: $e');
    }
  }

  @override
  Future<PatrolLocationModel> addPatrolLocation(String routeId, PatrolLocationModel location) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      return location.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        isAdditional: true,
      );
    } catch (e) {
      throw Exception('Failed to add patrol location: $e');
    }
  }

  @override
  Future<String> uploadProofImage(String imagePath) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock upload response
      return 'uploaded_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Helper method to calculate distance between two coordinates
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Earth radius in meters
    
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}