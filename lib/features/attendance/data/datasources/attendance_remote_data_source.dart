import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/entities/attendance_request.dart';
import '../models/attendance_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/image_compress_util.dart';
import '../../../../core/security/security_manager.dart';
import '../../../schedule/data/datasources/schedule_remote_data_source.dart';

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
  final ScheduleRemoteDataSource scheduleRemoteDataSource;

  AttendanceRemoteDataSourceImpl({
    required this.dio,
    required this.scheduleRemoteDataSource,
  });

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
      // Gunakan endpoint /Shift/get_current untuk cek apakah sudah check in
      final body = {'IdUser': userId};
      final response = await scheduleRemoteDataSource.getCurrentShift(body);
      
      // Cek field Checkin di response
      if (response.data != null) {
        return response.data!.checkin;
      }
      
      return false;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      // Jika error, return false agar user bisa submit check in
      return false;
    }
  }

  @override
  Future<AttendanceModel?> getCurrentAttendanceStatus(String userId) async {
    // Endpoint /attendance/current/$userId tidak ada di backend
    // Return null karena tidak ada data current attendance
    return null;
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
      
      final latitude = request.latitude ?? 0.0;
      final longitude = request.longitude ?? 0.0;

      final Map<String, dynamic> apiBody = {
        'PhotoAbsen': photoAbsen,
        'PhotoPakaian': photoPakaian,
        'PhotoPengamanan': firstSecurityPhoto,
        'Laporan': request.laporanPengamanan,
        'DeviceName': deviceName,
        'Latitude': latitude,
        'Longitude': longitude,
        'LocationName': request.lokasiTerkini,
        if (tokenPayload != null) 'Token': tokenPayload,
        // Hanya kirim IdShiftDetail jika tidak kosong/null (backend mengharapkan GUID yang valid)
        if (request.shiftDetailId != null && request.shiftDetailId!.isNotEmpty)
          'IdShiftDetail': request.shiftDetailId!,
      }..removeWhere((key, value) => value == null);

      final response = await dio.post(
        '/Attendance/check_in',
        data: apiBody,
      );

      // Handle response wrapper: {"Code":200,"Succeeded":true,"Message":"All OK","Description":""}
      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final code = responseData['Code'] as int?;
        final succeeded = responseData['Succeeded'] as bool?;
        final message = responseData['Message']?.toString().trim();
        final description = responseData['Description']?.toString().trim();
        
        // Jika response sukses (Code 200 dan Succeeded true), buat AttendanceModel dari request data
        if (code == 200 && succeeded == true) {
          final now = DateTime.now();
          // Buat AttendanceModel minimal dari request data karena response tidak mengembalikan data attendance
          return AttendanceModel(
            id: '', // ID akan diisi oleh backend, tapi untuk sementara kosong
            userId: request.userId,
            userName: '', // userName tidak ada di request, akan diisi kosong sementara
            type: AttendanceType.clockIn,
            shiftType: _parseShiftType(request.shift),
            timestamp: now,
            guardLocation: request.lokasiPenugasan,
            currentLocation: request.lokasiTerkini,
            latitude: latitude,
            longitude: longitude,
            personalClothing: request.pakaianPersonil,
            securityReport: request.laporanPengamanan,
            photoPath: request.fotoWajah,
            patrolRoute: request.ratePatrol,
            status: AttendanceStatus.checkIn,
            createdAt: now,
            updatedAt: now,
          );
        } else {
          final backendMessage = (message != null && message.isNotEmpty)
              ? message
              : ((description != null && description.isNotEmpty)
                  ? description
                  : 'Failed to check in');
          throw Exception(backendMessage);
        }
      }
      
      // Fallback: coba parse sebagai AttendanceModel langsung jika format berbeda
      return AttendanceModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(e.toString());
    }
  }

  @override
  Future<AttendanceModel> checkOut(CheckOutRequest request) async {
    try {
      final deviceName = await _resolveDeviceName();
      
      final photoAbsen = await _encodePhoto(request.fotoWajah);
      final photoPengamanan = request.fotoPengamanan.isNotEmpty
          ? await _encodePhoto(request.fotoPengamanan.first)
          : null;
      final photoLembur = request.buktiLaporan.isNotEmpty
          ? await _encodePhoto(request.buktiLaporan.first)
          : null;
      
      final latitude = request.latitude ?? 0.0;
      final longitude = request.longitude ?? 0.0;
      
      final Map<String, dynamic> apiBody = {
        if (photoAbsen != null) 'PhotoAbsen': photoAbsen,
        if (photoPengamanan != null) 'PhotoPengamanan': photoPengamanan,
        if (photoLembur != null) 'PhotoLembur': photoLembur,
        'Laporan': request.laporanPengamanan,
        'DeviceName': deviceName,
        'Latitude': latitude,
        'Longitude': longitude,
        'LocationName': request.lokasiPenugasanAkhir,
        if (request.coTask != null && request.coTask!.isNotEmpty)
          'CoTask': request.coTask,
        'IsOvertime': request.isOvertime,
        // Token tidak dikirim untuk checkout
        // Hanya kirim IdShiftDetail jika tidak kosong/null (backend mengharapkan GUID yang valid)
        if (request.shiftDetailId != null && request.shiftDetailId!.isNotEmpty)
          'IdShiftDetail': request.shiftDetailId!,
      }..removeWhere((key, value) => value == null);

      final response = await dio.post(
        '/Attendance/check_out',
        data: apiBody,
      );

      // Handle response wrapper: {"Code":200,"Succeeded":true,"Message":"All OK","Description":""}
      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final code = responseData['Code'] as int?;
        final succeeded = responseData['Succeeded'] as bool?;
        final message = responseData['Message']?.toString().trim();
        final description = responseData['Description']?.toString().trim();
        
        // Jika response sukses (Code 200 dan Succeeded true), buat AttendanceModel dari request data
        if (code == 200 && succeeded == true) {
          final now = DateTime.now();
          // Buat AttendanceModel minimal dari request data karena response tidak mengembalikan data attendance
          return AttendanceModel(
            id: '', // ID akan diisi oleh backend, tapi untuk sementara kosong
            userId: request.userId,
            userName: '', // userName tidak ada di request, akan diisi kosong sementara
            type: AttendanceType.clockOut,
            shiftType: ShiftType.morning, // Default, bisa disesuaikan jika ada di request
            timestamp: now,
            guardLocation: request.lokasiPenugasanAkhir,
            currentLocation: request.lokasiPenugasanAkhir,
            latitude: latitude,
            longitude: longitude,
            personalClothing: request.pakaianPersonil,
            securityReport: request.laporanPengamanan,
            photoPath: request.fotoWajah,
            patrolRoute: '', // Tidak ada di checkout request
            status: AttendanceStatus.checkIn,
            createdAt: now,
            updatedAt: now,
          );
        } else {
          final backendMessage = (message != null && message.isNotEmpty)
              ? message
              : ((description != null && description.isNotEmpty)
                  ? description
                  : 'Failed to check out');
          throw Exception(backendMessage);
        }
      }
      
      // Fallback: coba parse sebagai AttendanceModel langsung jika format berbeda
      return AttendanceModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> validateLocation(
      String currentLocation, String requiredLocation) async {
    // Endpoint /attendance/validate-location tidak ada di backend
    // Gunakan validasi lokal sederhana dengan string comparison
    final isValid = currentLocation.toLowerCase().trim() ==
        requiredLocation.toLowerCase().trim();
    return isValid;
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
      final file = await ImageCompressUtil.ensureMax1MbIfImage(path);
      final bytes = await file.readAsBytes();
      final base64Str = base64Encode(bytes);
      final filename = file.path.split(RegExp(r'[\/\\]')).last;
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

  ShiftType _parseShiftType(String shift) {
    final shiftLower = shift.toLowerCase();
    if (shiftLower.contains('pagi') || shiftLower.contains('morning')) {
      return ShiftType.morning;
    } else if (shiftLower.contains('malam') || shiftLower.contains('night')) {
      return ShiftType.night;
    }
    // Default ke morning jika tidak match
    return ShiftType.morning;
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

  String? _extractBackendMessage(DioException error) {
    final data = error.response?.data;
    Map<String, dynamic>? asMap;
    if (data is Map) {
      asMap = Map<String, dynamic>.from(data);
    } else if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) {
          asMap = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }

    if (asMap != null) {
      final dynamic message = asMap['Message'] ?? asMap['message'];
      final dynamic description = asMap['Description'] ?? asMap['description'];
      final messageStr = message?.toString().trim();
      final descriptionStr = description?.toString().trim();
      if (messageStr != null && messageStr.isNotEmpty) return messageStr;
      if (descriptionStr != null && descriptionStr.isNotEmpty) {
        return descriptionStr;
      }
    }
    return null;
  }

  Exception _handleDioError(DioException error) {
    final backendMessage = _extractBackendMessage(error);
    switch (error.response?.statusCode) {
      case 400:
        return Exception(backendMessage ?? 'Bad request');
      case 401:
        return Exception(backendMessage ?? 'Unauthorized');
      case 403:
        return Exception(backendMessage ?? 'Forbidden');
      case 404:
        return Exception(backendMessage ?? 'Not found');
      case 500:
        return Exception(backendMessage ?? 'Internal server error');
      default:
        return Exception(backendMessage ?? 'Network error: ${error.message}');
    }
  }
}
