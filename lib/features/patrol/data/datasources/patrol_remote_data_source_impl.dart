import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:math';
import 'dart:convert';
import '../models/patrol_route_model.dart';
import '../models/patrol_location_model.dart';
import '../models/patrol_attendance_model.dart';
import '../models/route_detail_api_response.dart';
import '../models/route_list_api_response.dart';
import '../models/area_list_api_response.dart';
import '../models/patrol_check_point_request.dart';
import '../../domain/entities/patrol_location.dart';
import 'patrol_remote_data_source.dart';

part 'patrol_remote_data_source_impl.g.dart';

@RestApi()
abstract class PatrolApiClient {
  factory PatrolApiClient(Dio dio, {String baseUrl}) = _PatrolApiClient;

  @POST('/Route/list')
  Future<RouteListResponse> getRouteList(
    @Body() RouteListRequest request,
  );

  @POST('/RouteDetail/list')
  Future<RouteDetailListResponse> getRouteDetailList(
    @Body() RouteDetailListRequest request,
  );

  @POST('/RouteDetail/add')
  @DioResponseType(ResponseType.json)
  Future<dynamic> addRouteDetail(
    @Body() Map<String, dynamic> request,
  );

  @POST('/Areas/list')
  Future<AreaListResponse> getAreaList(
    @Body() AreaListRequest request,
  );

  @POST('/Attendance/check_point')
  @DioResponseType(ResponseType.json)
  Future<dynamic> submitCheckPoint(
    @Body() PatrolCheckPointRequest request,
  );
}

@Injectable(as: PatrolRemoteDataSource)
class PatrolRemoteDataSourceImpl implements PatrolRemoteDataSource {
  final PatrolApiClient apiClient;

  PatrolRemoteDataSourceImpl(Dio dio) : apiClient = PatrolApiClient(dio);

  @override
  Future<RouteListResponse> getRouteList({
    required int start,
    required int length,
    List<FilterModel>? filter,
    SortModel? sort,
  }) async {
    try {
      final request = RouteListRequest(
        filter: filter ?? [],
        sort: sort ?? SortModel(field: '', type: 0),
        start: start,
        length: length,
      );

      final response = await apiClient.getRouteList(request);
      print(
          '[PatrolRemoteDataSource] Route List API Response: Count=${response.count}, Filtered=${response.filtered}, List length=${response.list.length}');
      return response;
    } catch (e) {
      print('[PatrolRemoteDataSource] Error: $e');
      throw Exception('Failed to load route list: $e');
    }
  }

  @override
  Future<RouteDetailListResponse> getRouteDetailList({
    required int start,
    required int length,
    List<FilterModel>? filter,
    SortModel? sort,
  }) async {
    try {
      final request = RouteDetailListRequest(
        filter: filter ?? [],
        sort: sort ?? SortModel(field: 'Name', type: 1),
        start: start,
        length: length,
      );

      final response = await apiClient.getRouteDetailList(request);
      print(
          '[PatrolRemoteDataSource] API Response: Count=${response.count}, Filtered=${response.filtered}, List length=${response.list?.length}');
      return response;
    } catch (e) {
      print('[PatrolRemoteDataSource] Error: $e');
      throw Exception('Failed to load route detail list: $e');
    }
  }

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
              latitude: -6.173056780703297,
              longitude: 106.78692883979942,
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
      final routeIndex = routes.indexWhere((route) => route.id == id);

      if (routeIndex == -1) {
        throw Exception('Route with id $id not found');
      }

      return routes[routeIndex];
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
  Future<bool> verifyLocation(double currentLat, double currentLng,
      double targetLat, double targetLng) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      // Calculate distance between current and target location
      final distance =
          _calculateDistance(currentLat, currentLng, targetLat, targetLng);

      // Return true if within 100 meters
      return distance <= 100;
    } catch (e) {
      throw Exception('Failed to verify location: $e');
    }
  }

  @override
  Future<PatrolLocationModel> addPatrolLocation(
      String routeId, PatrolLocationModel location) async {
    try {
      final request = {
        'IdRoute': routeId,
        'Latitude': location.latitude,
        'Longitude': location.longitude,
        'Name': location.name,
        'Radius': 100, // Default radius 100 meters
      };

      print('[PatrolRemoteDataSource] Adding location: $request');

      final response = await apiClient.addRouteDetail(request);

      print('[PatrolRemoteDataSource] Add location response: $response');

      // Return the location with updated data from response if available
      String locationId = DateTime.now().millisecondsSinceEpoch.toString();

      if (response != null && response is Map) {
        locationId = response['id']?.toString() ?? locationId;
      }

      return location.copyWith(
        id: locationId,
        isAdditional: true,
      );
    } catch (e) {
      print('[PatrolRemoteDataSource] Error adding location: $e');
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
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Earth radius in meters

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  @override
  Future<AreaListResponse> getAreaList({
    required int start,
    required int length,
    List<FilterModel>? filter,
    SortModel? sort,
  }) async {
    try {
      final request = AreaListRequest(
        filter: filter ?? [],
        sort: sort ?? SortModel(field: 'Name', type: 1),
        start: start,
        length: length,
      );

      // Log request details
      print('[PatrolRemoteDataSource] Areas List API Request:');
      print('  - Start: $start');
      print('  - Length: $length');
      print('  - Filters: ${filter?.map((f) => '${f.field}=${f.search}').join(', ') ?? 'none'}');
      print('  - Sort: ${sort?.field ?? 'none'}');
      
      final requestJson = request.toJson();
      print('[PatrolRemoteDataSource] Request JSON: $requestJson');

      final response = await apiClient.getAreaList(request);
      print(
          '[PatrolRemoteDataSource] Areas List API Response: Count=${response.count}, Filtered=${response.filtered}, List length=${response.list.length}');
      return response;
    } catch (e, stackTrace) {
      print('[PatrolRemoteDataSource] Error loading areas list: $e');
      print('[PatrolRemoteDataSource] Stack trace: $stackTrace');
      throw Exception('Failed to load areas list: $e');
    }
  }

  @override
  Future<bool> submitCheckPoint(PatrolCheckPointRequest request) async {
    try {
      print('[PatrolRemoteDataSource] Submitting check point...');
      
      final response = await apiClient.submitCheckPoint(request);
      
      // Handle response wrapper
      if (response is Map<String, dynamic>) {
        final code = response['Code'] as int?;
        final succeeded = response['Succeeded'] as bool?;
        
        if (succeeded == true && (code == 200 || code == null)) {
          print('[PatrolRemoteDataSource] Check point submitted successfully');
          return true;
        } else {
          final message = response['Message'] as String? ?? 'Failed to submit check point';
          final description = response['Description'] as String?;
          final errorMessage = description?.isNotEmpty == true 
              ? '$message\n$description' 
              : message;
          print('[PatrolRemoteDataSource] Check point submission failed: $errorMessage');
          throw CheckPointException(message);
        }
      }
      
      return true;
    } on CheckPointException {
      rethrow;
    } on DioException catch (e) {
      // Handle DioException which may contain response body
      print('[PatrolRemoteDataSource] DioException submitting check point: ${e.response?.statusCode}');
      print('[PatrolRemoteDataSource] DioException response data: ${e.response?.data}');
      
      // Try to extract error message from response
      String? errorMessage;
      
      if (e.response?.data != null) {
        // Handle if response.data is Map
        if (e.response!.data is Map<String, dynamic>) {
          final responseData = e.response!.data as Map<String, dynamic>;
          errorMessage = responseData['Message'] as String? ?? 
                        responseData['message'] as String?;
          if (errorMessage == null || errorMessage.isEmpty) {
            // Try to get from description or other fields
            errorMessage = responseData['Description'] as String? ?? 
                          responseData['description'] as String? ??
                          responseData['error'] as String?;
          }
        } 
        // Handle if response.data is String (JSON string)
        else if (e.response!.data is String) {
          try {
            final jsonData = jsonDecode(e.response!.data as String) as Map<String, dynamic>;
            errorMessage = jsonData['Message'] as String? ?? 
                          jsonData['message'] as String?;
          } catch (_) {
            // If not JSON, use the string as is
            errorMessage = e.response!.data as String;
          }
        }
      }
      
      // Use extracted message or fallback
      final finalMessage = errorMessage ?? 
                          e.response?.statusMessage ?? 
                          e.message ?? 
                          'Failed to submit check point';
      
      print('[PatrolRemoteDataSource] Error message extracted: $finalMessage');
      throw CheckPointException(finalMessage);
    } catch (e) {
      print('[PatrolRemoteDataSource] Error submitting check point: $e');
      // If it's already a CheckPointException, rethrow
      if (e is CheckPointException) {
        rethrow;
      }
      throw CheckPointException('Failed to submit check point: $e');
    }
  }
}

// Custom exception class for check point errors
class CheckPointException implements Exception {
  final String message;
  
  CheckPointException(this.message);
  
  @override
  String toString() => message;
}
