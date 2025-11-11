import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/shift_current_location_response.dart';

abstract class ShiftRemoteDataSource {
  Future<ShiftCurrentLocationResponse> getCurrentLocation({
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
    final body = {
      'Latitude': latitude,
      'Longitude': longitude,
    };
    final response = await dio.post(
      '/Shift/get_current_location',
      data: body,
    );
    return ShiftCurrentLocationResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

