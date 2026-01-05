import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';
import '../constants/enums.dart';
import '../security/security_manager.dart';
import '../utils/user_role_helper.dart';
import '../../features/attendance/domain/repositories/attendance_repository.dart';
import '../../features/attendance/domain/usecases/get_attendance_status_usecase.dart'
    show GetAttendanceStatusUseCase, UserAttendanceStatus;

/// Service untuk update lokasi user secara berkala
@lazySingleton
class LocationUpdateService {
  final Dio dio;
  final AttendanceRepository attendanceRepository;
  final GetAttendanceStatusUseCase getAttendanceStatusUseCase;

  LocationUpdateService({
    required this.dio,
    required this.attendanceRepository,
    required this.getAttendanceStatusUseCase,
  });

  /// Update lokasi user ke server
  /// Returns true jika berhasil, false jika gagal
  Future<bool> updateLocation() async {
    try {
      print('📍 [LocationUpdateService] Starting location update...');

      // 1. Check if user is logged in
      final isLoggedIn = await UserRoleHelper.isUserLoggedIn();
      if (!isLoggedIn) {
        print('📍 [LocationUpdateService] User not logged in, skipping update');
        return false;
      }

      // 2. Get user role
      final userRole = await UserRoleHelper.getUserRole();
      print('📍 [LocationUpdateService] User role: ${userRole.displayName}');

      // 3. Skip if user is pengawas
      if (userRole == UserRole.pengawas) {
        print('📍 [LocationUpdateService] User is pengawas, skipping update');
        return false;
      }

      // 4. Get user ID
      final userId = await UserRoleHelper.getUserId();
      if (userId == null || userId.isEmpty) {
        print('📍 [LocationUpdateService] User ID not found, skipping update');
        return false;
      }

      // 5. Check if user has checked in
      final attendanceStatusResult = await getAttendanceStatusUseCase(userId);
      final hasCheckedIn = attendanceStatusResult.fold(
        (failure) {
          print('📍 [LocationUpdateService] Failed to get attendance status: ${failure.message}');
          return false;
        },
        (result) => result.status == UserAttendanceStatus.checkedIn,
      );

      if (!hasCheckedIn) {
        print('📍 [LocationUpdateService] User has not checked in, skipping update');
        return false;
      }

      // 6. Get current location
      print('📍 [LocationUpdateService] Getting current location...');
      final position = await _getCurrentPosition();
      if (position == null) {
        print('📍 [LocationUpdateService] Failed to get current location');
        return false;
      }

      print('📍 [LocationUpdateService] Location: ${position.latitude}, ${position.longitude}');

      // 7. Get authentication token
      final token = await SecurityManager.readSecurely(AppConstants.tokenKey);
      if (token == null || token.isEmpty) {
        print('📍 [LocationUpdateService] Token not found, skipping update');
        return false;
      }

      // 8. Call API to update location
      print('📍 [LocationUpdateService] Calling API to update location...');
      final response = await dio.post(
        '/CurrentLocation/update',
        data: {
          'Latitude': position.latitude,
          'Longitude': position.longitude,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': '*/*',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('📍 [LocationUpdateService] Location updated successfully');
        return true;
      } else {
        print('📍 [LocationUpdateService] Failed to update location: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('📍 [LocationUpdateService] Error updating location: $e');
      return false;
    }
  }

  /// Get current position using geolocator
  Future<Position?> _getCurrentPosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('📍 [LocationUpdateService] Location services are disabled');
        return null;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('📍 [LocationUpdateService] Location permissions are denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('📍 [LocationUpdateService] Location permissions are permanently denied');
        return null;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      print('📍 [LocationUpdateService] Error getting current position: $e');
      return null;
    }
  }
}

