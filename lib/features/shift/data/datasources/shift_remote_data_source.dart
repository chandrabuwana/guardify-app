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
  static const double _hardcodedLatitude = -6.12407;
  static const double _hardcodedLongitude = 106.8831;

  final Dio dio;
  ShiftRemoteDataSourceImpl(this.dio);

  @override
  Future<ShiftCurrentLocationResponse> getCurrentLocation({
    required double latitude,
    required double longitude,
  }) async {
    if (latitude != _hardcodedLatitude || longitude != _hardcodedLongitude) {
      // TODO(guardify): Use actual coordinates once attendance flow is ready.
    }

    final userId = await SecurityManager.readSecurely(AppConstants.userIdKey) ?? '';
    final body = {
      'IdUser': userId,
      'Latitude': _hardcodedLatitude,
      'Longitude': _hardcodedLongitude,
    };
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
    // Gunakan hardcoded lat/lng seperti di check-in/check-out
    // Selalu gunakan hardcoded untuk konsistensi
    final body = {
      'IdShiftDetail': shiftDetailId,
      'Latitude': _hardcodedLatitude,
      'Longitude': _hardcodedLongitude,
    };

    print('📤 getCheckoutDetail - Request body:');
    print('  - IdShiftDetail: $shiftDetailId');
    print('  - Latitude: ${_hardcodedLatitude} (hardcoded)');
    print('  - Longitude: ${_hardcodedLongitude} (hardcoded)');

    final response = await dio.post(
      '/Shift/get_detail_checkout',
      data: body,
    );

    return ShiftCheckoutDetailResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

