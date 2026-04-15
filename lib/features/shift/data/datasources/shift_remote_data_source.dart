import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/security_manager.dart';
import '../models/shift_checkout_detail_response.dart';
import '../models/shift_current_location_response.dart';

abstract class ShiftRemoteDataSource {
  Future<ShiftCurrentLocationResponse> getCurrentLocation({
    required double latitude,
    required double longitude,
  });

  Future<ShiftCheckoutDetailResponse> getCheckoutDetail({
    required String shiftDetailId,
    required double latitude,
    required double longitude,
  });
}

@LazySingleton(as: ShiftRemoteDataSource)
class ShiftRemoteDataSourceImpl implements ShiftRemoteDataSource {
  final Dio dio;
  ShiftRemoteDataSourceImpl(this.dio);

  @override
  Future<ShiftCurrentLocationResponse> getCurrentLocation({
    required double latitude,
    required double longitude,
  }) async {
    // Use GPS coordinates from parameters (real device location)
    // Validate that coordinates are valid (not 0,0)
    if (latitude == 0.0 && longitude == 0.0) {
      print('⚠️ Warning: GPS coordinates are (0, 0) - GPS may not be available');
    }

    final userId = await SecurityManager.readSecurely(AppConstants.userIdKey) ?? '';
    final body = {
      'IdUser': userId,
      'Latitude': latitude, // Use real GPS coordinates
      'Longitude': longitude, // Use real GPS coordinates
    };
    
    print('📍 getCurrentLocation - Using GPS real device:');
    print('  Latitude: $latitude');
    print('  Longitude: $longitude');
    final response = await dio.post(
      '/Shift/get_current_location',
      data: body,
    );
    return ShiftCurrentLocationResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ShiftCheckoutDetailResponse> getCheckoutDetail({
    required String shiftDetailId,
    required double latitude,
    required double longitude,
  }) async {
    // Use GPS coordinates from parameters (real device location)
    // Validate that coordinates are valid (not 0,0)
    if (latitude == 0.0 && longitude == 0.0) {
      print('⚠️ Warning: GPS coordinates are (0, 0) - GPS may not be available');
    }
    
    final body = {
      'IdShiftDetail': shiftDetailId,
      'Latitude': latitude, // Use real GPS coordinates
      'Longitude': longitude, // Use real GPS coordinates
    };

    print('📤 getCheckoutDetail - Request body:');
    print('  - IdShiftDetail: $shiftDetailId');
    print('  - Latitude: $latitude (GPS real device)');
    print('  - Longitude: $longitude (GPS real device)');

    final response = await dio.post(
      '/Shift/get_detail_checkout',
      data: body,
    );

    return ShiftCheckoutDetailResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

