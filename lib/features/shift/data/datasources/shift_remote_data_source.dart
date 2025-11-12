import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/security_manager.dart';
import '../models/shift_current_location_response.dart';

abstract class ShiftRemoteDataSource {
  Future<ShiftCurrentLocationResponse> getCurrentLocation({
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

    final tokenPayload = await _buildTokenPayload();

    final body = {
      'Latitude': _hardcodedLatitude,
      'Longitude': _hardcodedLongitude,
      if (tokenPayload != null) 'Token': tokenPayload,
    };
    final response = await dio.post(
      '/Shift/get_current_location',
      data: body,
    );
    return ShiftCurrentLocationResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>?> _buildTokenPayload() async {
    final userId = await SecurityManager.readSecurely(AppConstants.userIdKey);
    final roleId = await SecurityManager.readSecurely('user_role_id');
    final roleName = await SecurityManager.readSecurely('user_role_name');
    final username = await SecurityManager.readSecurely('user_username');
    final fullName = await SecurityManager.readSecurely('user_fullname');
    final mail = await SecurityManager.readSecurely('user_mail');

    final hasUserInfo = [
      userId,
      roleId,
      roleName,
      username,
      fullName,
      mail,
    ].any((value) => value != null && value.isNotEmpty);

    if (!hasUserInfo) return null;

    return {
      'Id': userId ?? '',
      'Role': [
        {
          'Id': roleId ?? '',
          'Nama': roleName ?? '',
        },
      ],
      'Username': username ?? '',
      'FullName': fullName ?? '',
      'Mail': mail ?? '',
    };
  }
}

