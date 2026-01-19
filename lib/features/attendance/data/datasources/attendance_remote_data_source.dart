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
      // ========== LOGGING START ==========
      print('═══════════════════════════════════════════════════════════');
      print('🚀 [Attendance/check_in] REQUEST START');
      print('═══════════════════════════════════════════════════════════');
      
      // Log request details
      print('📋 Request Details:');
      print('  Endpoint: /Attendance/check_in');
      print('  Method: POST');
      print('  userId: ${request.userId}');
      print('  shift: ${request.shift}');
      print('  shiftDetailId: ${request.shiftDetailId ?? "null"}');
      print('  lokasiPenugasan: ${request.lokasiPenugasan}');
      print('  lokasiTerkini: ${request.lokasiTerkini}');
      print('  ratePatrol: ${request.ratePatrol}');
      print('  laporanPengamanan: ${request.laporanPengamanan}');
      print('  latitude: ${request.latitude ?? "null"}');
      print('  longitude: ${request.longitude ?? "null"}');
      
      // Log photo paths
      print('📸 Photo Paths:');
      print('  fotoWajah: ${request.fotoWajah ?? "null"}');
      print('  pakaianPersonil: ${request.pakaianPersonil}');
      print('  fotoPengamanan count: ${request.fotoPengamanan.length}');
      for (int i = 0; i < request.fotoPengamanan.length; i++) {
        print('    fotoPengamanan[$i]: ${request.fotoPengamanan[i]}');
      }
      
      final deviceName = await _resolveDeviceName();
      print('📱 Device Info:');
      print('  DeviceName: $deviceName');
      
      final photoAbsen = await _encodePhoto(request.fotoWajah);
      final photoPakaian = await _encodePhoto(request.pakaianPersonil);
      final firstSecurityPhoto = request.fotoPengamanan.isNotEmpty
          ? await _encodePhoto(request.fotoPengamanan.first)
          : null;
      final tokenPayload = await _buildTokenPayload();

      // Log encoded photos summary
      print('📸 Encoded Photos Summary:');
      print('  photoAbsen: ${photoAbsen != null ? "✅ encoded (${photoAbsen['Filename']}, ${photoAbsen['MimeType']}, base64Length: ${(photoAbsen['Base64'] as String).length})" : "❌ null"}');
      print('  photoPakaian: ${photoPakaian != null ? "✅ encoded (${photoPakaian['Filename']}, ${photoPakaian['MimeType']}, base64Length: ${(photoPakaian['Base64'] as String).length})" : "❌ null"}');
      print('  photoPengamanan: ${firstSecurityPhoto != null ? "✅ encoded (${firstSecurityPhoto['Filename']}, ${firstSecurityPhoto['MimeType']}, base64Length: ${(firstSecurityPhoto['Base64'] as String).length})" : "❌ null"}');
      
      // Log token payload
      if (tokenPayload != null) {
        print('🔑 Token Payload:');
        final jsonEncoder = JsonEncoder.withIndent('  ');
        print(jsonEncoder.convert(tokenPayload));
      } else {
        print('🔑 Token Payload: null');
      }

      // Use GPS coordinates from request (real device location)
      // If lat/lng is 0 or null, it means GPS is not available - should not happen in production
      if (request.latitude == null || request.latitude == 0 || 
          request.longitude == null || request.longitude == 0) {
        print('⚠️ Warning: GPS coordinates are missing or invalid');
        print('  Latitude: ${request.latitude ?? "null"}');
        print('  Longitude: ${request.longitude ?? "null"}');
        // Still use the provided values (even if 0) - let backend handle validation
      }
      
      final latitude = request.latitude ?? 0.0;
      final longitude = request.longitude ?? 0.0;
      
      print('📍 Location (GPS real device):');
      print('  Latitude: $latitude');
      print('  Longitude: $longitude');

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

      // Log full payload (with base64 truncated for readability)
      print('📦 Full Payload:');
      final payloadForLog = Map<String, dynamic>.from(apiBody);
      
      // Truncate base64 strings for logging (show first 50 chars)
      if (payloadForLog['PhotoAbsen'] is Map) {
        final photoAbsenMap = Map<String, dynamic>.from(payloadForLog['PhotoAbsen'] as Map);
        if (photoAbsenMap['Base64'] is String) {
          final base64 = photoAbsenMap['Base64'] as String;
          photoAbsenMap['Base64'] = base64.length > 50 
              ? '${base64.substring(0, 50)}... (truncated, total length: ${base64.length})'
              : base64;
        }
        payloadForLog['PhotoAbsen'] = photoAbsenMap;
      }
      
      if (payloadForLog['PhotoPakaian'] is Map) {
        final photoPakaianMap = Map<String, dynamic>.from(payloadForLog['PhotoPakaian'] as Map);
        if (photoPakaianMap['Base64'] is String) {
          final base64 = photoPakaianMap['Base64'] as String;
          photoPakaianMap['Base64'] = base64.length > 50 
              ? '${base64.substring(0, 50)}... (truncated, total length: ${base64.length})'
              : base64;
        }
        payloadForLog['PhotoPakaian'] = photoPakaianMap;
      }
      
      if (payloadForLog['PhotoPengamanan'] is Map) {
        final photoPengamananMap = Map<String, dynamic>.from(payloadForLog['PhotoPengamanan'] as Map);
        if (photoPengamananMap['Base64'] is String) {
          final base64 = photoPengamananMap['Base64'] as String;
          photoPengamananMap['Base64'] = base64.length > 50 
              ? '${base64.substring(0, 50)}... (truncated, total length: ${base64.length})'
              : base64;
        }
        payloadForLog['PhotoPengamanan'] = photoPengamananMap;
      }
      
      // Print formatted JSON
      final jsonEncoder = JsonEncoder.withIndent('  ');
      print(jsonEncoder.convert(payloadForLog));
      
      print('═══════════════════════════════════════════════════════════');
      // ========== LOGGING END ==========

      final response = await dio.post(
        '/Attendance/check_in',
        data: apiBody,
      );

      // ========== RESPONSE LOGGING ==========
      print('═══════════════════════════════════════════════════════════');
      print('✅ [Attendance/check_in] RESPONSE RECEIVED');
      print('═══════════════════════════════════════════════════════════');
      print('📊 Response Status: ${response.statusCode}');
      print('📊 Response Headers:');
      response.headers.forEach((key, values) {
        print('  $key: ${values.join(", ")}');
      });
      print('📊 Response Data:');
      print(jsonEncoder.convert(response.data));
      print('═══════════════════════════════════════════════════════════');
      // ========== RESPONSE LOGGING END ==========

      // Handle response wrapper: {"Code":200,"Succeeded":true,"Message":"All OK","Description":""}
      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final code = responseData['Code'] as int?;
        final succeeded = responseData['Succeeded'] as bool?;
        
        print('📊 Response Analysis:');
        print('  Code: $code');
        print('  Succeeded: $succeeded');
        print('  Message: ${responseData['Message'] ?? "null"}');
        print('  Description: ${responseData['Description'] ?? "null"}');
        
        // Jika response sukses (Code 200 dan Succeeded true), buat AttendanceModel dari request data
        if (code == 200 && succeeded == true) {
          print('✅ [Attendance/check_in] SUCCESS');
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
          print('❌ [Attendance/check_in] FAILED: Code=$code, Succeeded=$succeeded');
        }
      }
      
      // Fallback: coba parse sebagai AttendanceModel langsung jika format berbeda
      print('⚠️ [Attendance/check_in] Using fallback parsing');
      return AttendanceModel.fromJson(response.data);
    } on DioException catch (e) {
      // ========== ERROR LOGGING ==========
      print('═══════════════════════════════════════════════════════════');
      print('❌ [Attendance/check_in] DIO EXCEPTION');
      print('═══════════════════════════════════════════════════════════');
      print('Error Type: DioException');
      print('Error Message: ${e.message}');
      print('Error Type: ${e.type}');
      
      if (e.response != null) {
        print('Response Status Code: ${e.response?.statusCode}');
        print('Response Status Message: ${e.response?.statusMessage}');
        print('Response Data:');
        try {
          final jsonEncoder = JsonEncoder.withIndent('  ');
          print(jsonEncoder.convert(e.response?.data));
        } catch (_) {
          print(e.response?.data);
        }
        
        final errorMessage = e.response?.data['Message'] ??
            e.response?.data['Description'] ??
            'Failed to check in';
        print('Extracted Error Message: $errorMessage');
      } else {
        print('No response data available');
        print('Request Options:');
        print('  Method: ${e.requestOptions.method}');
        print('  URL: ${e.requestOptions.uri}');
        print('  Headers: ${e.requestOptions.headers}');
      }
      print('═══════════════════════════════════════════════════════════');
      // ========== ERROR LOGGING END ==========
      
      throw _handleDioError(e);
    } catch (e) {
      // ========== GENERAL ERROR LOGGING ==========
      print('═══════════════════════════════════════════════════════════');
      print('❌ [Attendance/check_in] GENERAL EXCEPTION');
      print('═══════════════════════════════════════════════════════════');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      print('Stack Trace:');
      print(StackTrace.current);
      print('═══════════════════════════════════════════════════════════');
      // ========== GENERAL ERROR LOGGING END ==========
      
      throw Exception('Failed to check in: $e');
    }
  }

  @override
  Future<AttendanceModel> checkOut(CheckOutRequest request) async {
    try {
      // ========== LOGGING START ==========
      print('═══════════════════════════════════════════════════════════');
      print('🚀 [Attendance/check_out] REQUEST START');
      print('═══════════════════════════════════════════════════════════');
      
      // Log request details
      print('📋 Request Details:');
      print('  Endpoint: /Attendance/check_out');
      print('  Method: POST');
      print('  userId: ${request.userId}');
      print('  attendanceId: ${request.attendanceId}');
      print('  shiftDetailId: ${request.shiftDetailId ?? "null"}');
      print('  lokasiPenugasanAkhir: ${request.lokasiPenugasanAkhir}');
      print('  statusTugas: ${request.statusTugas}');
      print('  laporanPengamanan: ${request.laporanPengamanan}');
      print('  coTask: ${request.coTask ?? "null"}');
      print('  isOvertime: ${request.isOvertime}');
      print('  latitude: ${request.latitude ?? "null"}');
      print('  longitude: ${request.longitude ?? "null"}');
      
      // Log photo paths
      print('📸 Photo Paths:');
      print('  fotoWajah: ${request.fotoWajah ?? "null"}');
      print('  pakaianPersonil: ${request.pakaianPersonil}');
      print('  fotoPengamanan count: ${request.fotoPengamanan.length}');
      for (int i = 0; i < request.fotoPengamanan.length; i++) {
        print('    fotoPengamanan[$i]: ${request.fotoPengamanan[i]}');
      }
      print('  buktiLaporan count: ${request.buktiLaporan.length}');
      for (int i = 0; i < request.buktiLaporan.length; i++) {
        print('    buktiLaporan[$i]: ${request.buktiLaporan[i]}');
      }
      
      final deviceName = await _resolveDeviceName();
      print('📱 Device Info:');
      print('  DeviceName: $deviceName');
      
      final photoAbsen = await _encodePhoto(request.fotoWajah);
      final photoPengamanan = request.fotoPengamanan.isNotEmpty
          ? await _encodePhoto(request.fotoPengamanan.first)
          : null;
      final photoLembur = request.buktiLaporan.isNotEmpty
          ? await _encodePhoto(request.buktiLaporan.first)
          : null;

      // Log encoded photos summary
      print('📸 Encoded Photos Summary:');
      print('  photoAbsen: ${photoAbsen != null ? "✅ encoded (${photoAbsen['Filename']}, ${photoAbsen['MimeType']}, base64Length: ${(photoAbsen['Base64'] as String).length})" : "❌ null"}');
      print('  photoPengamanan: ${photoPengamanan != null ? "✅ encoded (${photoPengamanan['Filename']}, ${photoPengamanan['MimeType']}, base64Length: ${(photoPengamanan['Base64'] as String).length})" : "❌ null"}');
      print('  photoLembur: ${photoLembur != null ? "✅ encoded (${photoLembur['Filename']}, ${photoLembur['MimeType']}, base64Length: ${(photoLembur['Base64'] as String).length})" : "❌ null"}');

      // Use GPS coordinates from request (real device location)
      // If lat/lng is 0 or null, it means GPS is not available - should not happen in production
      if (request.latitude == null || request.latitude == 0 || 
          request.longitude == null || request.longitude == 0) {
        print('⚠️ Warning: GPS coordinates are missing or invalid');
        print('  Latitude: ${request.latitude ?? "null"}');
        print('  Longitude: ${request.longitude ?? "null"}');
        // Still use the provided values (even if 0) - let backend handle validation
      }
      
      final latitude = request.latitude ?? 0.0;
      final longitude = request.longitude ?? 0.0;
      
      print('📍 Location (GPS real device):');
      print('  Latitude: $latitude');
      print('  Longitude: $longitude');
      
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

      // Log full payload (with base64 truncated for readability)
      print('📦 Full Payload:');
      final payloadForLog = Map<String, dynamic>.from(apiBody);
      
      // Truncate base64 strings for logging (show first 50 chars)
      if (payloadForLog['PhotoAbsen'] is Map) {
        final photoAbsenMap = Map<String, dynamic>.from(payloadForLog['PhotoAbsen'] as Map);
        if (photoAbsenMap['Base64'] is String) {
          final base64 = photoAbsenMap['Base64'] as String;
          photoAbsenMap['Base64'] = base64.length > 50 
              ? '${base64.substring(0, 50)}... (truncated, total length: ${base64.length})'
              : base64;
        }
        payloadForLog['PhotoAbsen'] = photoAbsenMap;
      }
      
      if (payloadForLog['PhotoPengamanan'] is Map) {
        final photoPengamananMap = Map<String, dynamic>.from(payloadForLog['PhotoPengamanan'] as Map);
        if (photoPengamananMap['Base64'] is String) {
          final base64 = photoPengamananMap['Base64'] as String;
          photoPengamananMap['Base64'] = base64.length > 50 
              ? '${base64.substring(0, 50)}... (truncated, total length: ${base64.length})'
              : base64;
        }
        payloadForLog['PhotoPengamanan'] = photoPengamananMap;
      }
      
      if (payloadForLog['PhotoLembur'] is Map) {
        final photoLemburMap = Map<String, dynamic>.from(payloadForLog['PhotoLembur'] as Map);
        if (photoLemburMap['Base64'] is String) {
          final base64 = photoLemburMap['Base64'] as String;
          photoLemburMap['Base64'] = base64.length > 50 
              ? '${base64.substring(0, 50)}... (truncated, total length: ${base64.length})'
              : base64;
        }
        payloadForLog['PhotoLembur'] = photoLemburMap;
      }
      
      // Print formatted JSON
      final jsonEncoder = JsonEncoder.withIndent('  ');
      print(jsonEncoder.convert(payloadForLog));
      
      print('═══════════════════════════════════════════════════════════');
      // ========== LOGGING END ==========

      final response = await dio.post(
        '/Attendance/check_out',
        data: apiBody,
      );

      // ========== RESPONSE LOGGING ==========
      print('═══════════════════════════════════════════════════════════');
      print('✅ [Attendance/check_out] RESPONSE RECEIVED');
      print('═══════════════════════════════════════════════════════════');
      print('📊 Response Status: ${response.statusCode}');
      print('📊 Response Headers:');
      response.headers.forEach((key, values) {
        print('  $key: ${values.join(", ")}');
      });
      print('📊 Response Data:');
      print(jsonEncoder.convert(response.data));
      print('═══════════════════════════════════════════════════════════');
      // ========== RESPONSE LOGGING END ==========

      // Handle response wrapper: {"Code":200,"Succeeded":true,"Message":"All OK","Description":""}
      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final code = responseData['Code'] as int?;
        final succeeded = responseData['Succeeded'] as bool?;
        
        print('📊 Response Analysis:');
        print('  Code: $code');
        print('  Succeeded: $succeeded');
        print('  Message: ${responseData['Message'] ?? "null"}');
        print('  Description: ${responseData['Description'] ?? "null"}');
        
        // Jika response sukses (Code 200 dan Succeeded true), buat AttendanceModel dari request data
        if (code == 200 && succeeded == true) {
          print('✅ [Attendance/check_out] SUCCESS');
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
          print('❌ [Attendance/check_out] FAILED: Code=$code, Succeeded=$succeeded');
        }
      }
      
      // Fallback: coba parse sebagai AttendanceModel langsung jika format berbeda
      print('⚠️ [Attendance/check_out] Using fallback parsing');
      return AttendanceModel.fromJson(response.data);
    } on DioException catch (e) {
      // ========== ERROR LOGGING ==========
      print('═══════════════════════════════════════════════════════════');
      print('❌ [Attendance/check_out] DIO EXCEPTION');
      print('═══════════════════════════════════════════════════════════');
      print('Error Type: DioException');
      print('Error Message: ${e.message}');
      print('Error Type: ${e.type}');
      
      if (e.response != null) {
        print('Response Status Code: ${e.response?.statusCode}');
        print('Response Status Message: ${e.response?.statusMessage}');
        print('Response Data:');
        try {
          final jsonEncoder = JsonEncoder.withIndent('  ');
          print(jsonEncoder.convert(e.response?.data));
        } catch (_) {
          print(e.response?.data);
        }
        
        final errorMessage = e.response?.data['Message'] ??
            e.response?.data['Description'] ??
            'Failed to check out';
        print('Extracted Error Message: $errorMessage');
      } else {
        print('No response data available');
        print('Request Options:');
        print('  Method: ${e.requestOptions.method}');
        print('  URL: ${e.requestOptions.uri}');
        print('  Headers: ${e.requestOptions.headers}');
      }
      print('═══════════════════════════════════════════════════════════');
      // ========== ERROR LOGGING END ==========
      
      throw _handleDioError(e);
    } catch (e) {
      // ========== GENERAL ERROR LOGGING ==========
      print('═══════════════════════════════════════════════════════════');
      print('❌ [Attendance/check_out] GENERAL EXCEPTION');
      print('═══════════════════════════════════════════════════════════');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      print('Stack Trace:');
      print(StackTrace.current);
      print('═══════════════════════════════════════════════════════════');
      // ========== GENERAL ERROR LOGGING END ==========
      
      throw Exception('Failed to check out: $e');
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
