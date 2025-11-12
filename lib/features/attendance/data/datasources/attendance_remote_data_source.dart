import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/entities/attendance_request.dart';
import '../models/attendance_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/security_manager.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceModel> submitAttendance(AttendanceModel attendance);
  Future<List<AttendanceModel>> getAttendanceHistory(String userId);
  Future<AttendanceModel> getAttendanceById(String attendanceId);
  Future<bool> hasCheckedInToday(String userId);
  Future<AttendanceModel?> getCurrentAttendanceStatus(String userId);
  Future<AttendanceModel> updateAttendanceStatus({
    required String attendanceId,
    required AttendanceStatus status,
    String? rejectionReason,
    String? approvedBy,
  });
  Future<List<AttendanceModel>> getPendingApprovals(String userRole);

  // New methods for check in/out flow
  Future<AttendanceModel> checkIn(CheckInRequest request);
  Future<AttendanceModel> checkOut(CheckOutRequest request);
  Future<bool> validateLocation(
      String currentLocation, String requiredLocation);
}

@LazySingleton(as: AttendanceRemoteDataSource)
class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final Dio dio;

  AttendanceRemoteDataSourceImpl({required this.dio});

  @override
  Future<AttendanceModel> submitAttendance(AttendanceModel attendance) async {
    try {
      final response = await dio.post(
        '/attendance',
        data: attendance.toJson(),
      );

      return AttendanceModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<AttendanceModel>> getAttendanceHistory(String userId) async {
    try {
      final response = await dio.get('/attendance/history/$userId');

      return (response.data as List)
          .map((json) => AttendanceModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AttendanceModel> getAttendanceById(String attendanceId) async {
    try {
      final response = await dio.get('/attendance/$attendanceId');

      return AttendanceModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<bool> hasCheckedInToday(String userId) async {
    try {
      final response = await dio.get('/attendance/check-today/$userId');

      return response.data['hasCheckedIn'] as bool;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AttendanceModel?> getCurrentAttendanceStatus(String userId) async {
    try {
      final response = await dio.get('/attendance/current/$userId');

      if (response.data == null) return null;

      return AttendanceModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AttendanceModel> updateAttendanceStatus({
    required String attendanceId,
    required AttendanceStatus status,
    String? rejectionReason,
    String? approvedBy,
  }) async {
    try {
      final response = await dio.put(
        '/attendance/$attendanceId/status',
        data: {
          'status': status.name,
          'rejectionReason': rejectionReason,
          'approvedBy': approvedBy,
        },
      );

      return AttendanceModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<AttendanceModel>> getPendingApprovals(String userRole) async {
    try {
      final response = await dio.get('/attendance/pending/$userRole');

      return (response.data as List)
          .map((json) => AttendanceModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AttendanceModel> checkIn(CheckInRequest request) async {
    try {
      final deviceName = await _resolveDeviceName();
      final photoAbsen = await _encodePhoto(request.fotoWajah);
      final photoPakaian = await _encodePhoto(request.pakaianPersonil);
      final firstSecurityPhoto = request.fotoPengamanan.isNotEmpty
          ? await _encodePhoto(request.fotoPengamanan.first)
          : null;
      final tokenPayload = await _buildTokenPayload();

      final Map<String, dynamic> apiBody = {
        'IdShiftDetail': request.shiftDetailId ?? '',
        'PhotoAbsen': photoAbsen,
        'PhotoPakaian': photoPakaian,
        'PhotoPengamanan': firstSecurityPhoto,
        'Laporan': request.laporanPengamanan,
        'DeviceName': deviceName,
        'Latitude': request.latitude ?? 0,
        'Longitude': request.longitude ?? 0,
        'LocationName': request.lokasiTerkini,
        if (tokenPayload != null) 'Token': tokenPayload,
      }..removeWhere((key, value) => value == null);

      final response = await dio.post(
        '/Attendance/check_in',
        data: apiBody,
      );

      return AttendanceModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AttendanceModel> checkOut(CheckOutRequest request) async {
    try {
      final response = await dio.post(
        '/attendance/checkout',
        data: request.toJson(),
      );

      return AttendanceModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<bool> validateLocation(
      String currentLocation, String requiredLocation) async {
    try {
      final response = await dio.post(
        '/attendance/validate-location',
        data: {
          'currentLocation': currentLocation,
          'requiredLocation': requiredLocation,
        },
      );

      return response.data['isValid'] as bool;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<String> _resolveDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceName = 'Unknown Device';
    try {
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        deviceName = '${info.manufacturer} ${info.model}';
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        final machine = info.utsname.machine;
        deviceName = machine.isNotEmpty ? machine : 'iPhone';
      }
    } catch (_) {}
    return deviceName;
  }

  Future<Map<String, dynamic>?> _encodePhoto(String? path) async {
    if (path == null || path.isEmpty) return null;
    try {
      final file = File(path);
      if (!await file.exists()) return null;
      final bytes = await file.readAsBytes();
      final base64Str = base64Encode(bytes);
      final filename = path.split(RegExp(r'[\/\\]')).last;
      final ext = filename.contains('.') ? filename.split('.').last.toLowerCase() : '';
      final mime = _guessMimeType(ext);
      return {
        'Filename': filename,
        'MimeType': mime,
        'Base64': base64Str,
      };
    } catch (_) {
      return null;
    }
  }

  String _guessMimeType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'heic':
        return 'image/heic';
      default:
        return 'application/octet-stream';
    }
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

  Exception _handleDioError(DioException error) {
    switch (error.response?.statusCode) {
      case 400:
        return Exception('Bad request: ${error.response?.data['message']}');
      case 401:
        return Exception('Unauthorized');
      case 403:
        return Exception('Forbidden');
      case 404:
        return Exception('Not found');
      case 500:
        return Exception('Internal server error');
      default:
        return Exception('Network error: ${error.message}');
    }
  }
}
