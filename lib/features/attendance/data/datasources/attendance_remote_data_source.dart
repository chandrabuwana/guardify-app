import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/entities/attendance_request.dart';
import '../models/attendance_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

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
      // Map request to external API schema provided by backend
      final deviceInfo = DeviceInfoPlugin();
      String deviceName = 'Unknown Device';
      try {
        if (Platform.isAndroid) {
          final info = await deviceInfo.androidInfo;
          deviceName = '${info.manufacturer} ${info.model}';
        } else if (Platform.isIOS) {
          final info = await deviceInfo.iosInfo;
          deviceName = info.utsname.machine ?? 'iPhone';
        }
      } catch (_) {}

      Map<String, dynamic>? photoFromPath(String? path) {
        if (path == null || path.isEmpty) return null;
        try {
          final file = File(path);
          if (!file.existsSync()) return null;
          final bytes = file.readAsBytesSync();
          final base64Str = base64Encode(bytes);
          final filename = path.split('/').last;
          final ext = filename.split('.').last.toLowerCase();
          final mime = switch (ext) {
            'jpg' || 'jpeg' => 'image/jpeg',
            'png' => 'image/png',
            'gif' => 'image/gif',
            _ => 'application/octet-stream',
          };
          return {
            'Filename': filename,
            'MimeType': mime,
            'Base64': base64Str,
          };
        } catch (_) {
          return null;
        }
      }

      final Map<String, dynamic> apiBody = {
        'PhotoAbsen': photoFromPath(request.fotoWajah),
        'PhotoPakaian': photoFromPath(request.pakaianPersonil),
        'PhotoPengamanan': request.fotoPengamanan.isNotEmpty
            ? photoFromPath(request.fotoPengamanan.first)
            : null,
        'Laporan': request.laporanPengamanan,
        'DeviceName': deviceName,
        'Latitude': request.latitude ?? 0,
        'Longitude': request.longitude ?? 0,
        'LocationName': request.lokasiTerkini,
        // Token is handled by Authorization header in this project; body Token is optional
        'Token': null,
      };

      final response = await dio.post('/attendance/checkin', data: apiBody);

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
