import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/attendance_rekap_model.dart';
import '../../domain/entities/attendance_rekap_request_entity.dart';
import '../../domain/entities/attendance_update_request.dart';

import '../models/attendance_rekap_detail_model.dart';

abstract class AttendanceRekapRemoteDataSource {
  Future<AttendanceRekapResponseModel> getRekap(
      AttendanceRekapRequestEntity request);
  
  Future<AttendanceRekapDetailResponseModel> getDetail(String idAttendance);
  
  Future<void> updateAttendance(AttendanceUpdateRequest request);
}

@LazySingleton(as: AttendanceRekapRemoteDataSource)
class AttendanceRekapRemoteDataSourceImpl
    implements AttendanceRekapRemoteDataSource {
  final Dio dio;

  AttendanceRekapRemoteDataSourceImpl({required this.dio});

  @override
  Future<AttendanceRekapResponseModel> getRekap(
      AttendanceRekapRequestEntity request) async {
    try {
      final response = await dio.post(
        '/Attendance/get_rekap',
        data: request.toJson(),
      );

      // Handle response wrapper
      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;
        
        // Check if response has the expected structure
        if (responseData.containsKey('Succeeded') &&
            responseData['Succeeded'] == true) {
          return AttendanceRekapResponseModel.fromJson(responseData);
        } else {
          throw Exception(
              responseData['Message'] ?? 'Failed to get attendance recap');
        }
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data['Message'] ??
            e.response?.data['Description'] ??
            'Failed to get attendance recap';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get attendance recap: $e');
    }
  }

  @override
  Future<AttendanceRekapDetailResponseModel> getDetail(
      String idAttendance) async {
    try {
      final response = await dio.post(
        '/Attendance/get_detail_rekap',
        data: {'IdAttendance': idAttendance},
      );

      // Handle response wrapper
      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;
        
        // Check if response has the expected structure
        if (responseData.containsKey('Succeeded') &&
            responseData['Succeeded'] == true) {
          return AttendanceRekapDetailResponseModel.fromJson(responseData);
        } else {
          throw Exception(
              responseData['Message'] ?? 'Failed to get attendance recap detail');
        }
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data['Message'] ??
            e.response?.data['Description'] ??
            'Failed to get attendance recap detail';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get attendance recap detail: $e');
    }
  }

  @override
  Future<void> updateAttendance(AttendanceUpdateRequest request) async {
    try {
      // ========== LOGGING START ==========
      print('═══════════════════════════════════════════════════════════');
      print('🚀 [Attendance/update] REQUEST START');
      print('═══════════════════════════════════════════════════════════');
      
      // Log request details
      print('📋 Request Details:');
      print('  Endpoint: /Attendance/update');
      print('  Method: POST');
      print('  IdAttendance: ${request.idAttendance}');
      print('  Laporan: ${request.laporan ?? "null"}');
      print('  LaporanCheckout: ${request.laporanCheckout ?? "null"}');
      print('  IsOvertime: ${request.isOvertime ?? "null"}');
      
      // Log photo paths
      print('📸 Photo Paths:');
      print('  photoAbsenPath: ${request.photoAbsenPath ?? "null"}');
      print('  photoPengamananPath: ${request.photoPengamananPath ?? "null"}');
      print('  photoPakaianPath: ${request.photoPakaianPath ?? "null"}');
      print('  photoOvertimePath: ${request.photoOvertimePath ?? "null"}');

      final photoAbsen = await _encodePhoto(request.photoAbsenPath);
      final photoPengamanan = await _encodePhoto(request.photoPengamananPath);
      final photoPakaian = await _encodePhoto(request.photoPakaianPath);
      final photoOvertime = await _encodePhoto(request.photoOvertimePath);

      // Log encoded photos summary
      print('📸 Encoded Photos Summary:');
      print('  photoAbsen: ${photoAbsen != null ? "✅ encoded (${photoAbsen['Filename']}, ${photoAbsen['MimeType']}, base64Length: ${(photoAbsen['Base64'] as String).length})" : "❌ null"}');
      print('  photoPengamanan: ${photoPengamanan != null ? "✅ encoded (${photoPengamanan['Filename']}, ${photoPengamanan['MimeType']}, base64Length: ${(photoPengamanan['Base64'] as String).length})" : "❌ null"}');
      print('  photoPakaian: ${photoPakaian != null ? "✅ encoded (${photoPakaian['Filename']}, ${photoPakaian['MimeType']}, base64Length: ${(photoPakaian['Base64'] as String).length})" : "❌ null"}');
      print('  photoOvertime: ${photoOvertime != null ? "✅ encoded (${photoOvertime['Filename']}, ${photoOvertime['MimeType']}, base64Length: ${(photoOvertime['Base64'] as String).length})" : "❌ null"}');

      final Map<String, dynamic> apiBody = {
        'IdAttendance': request.idAttendance,
        // Always include PhotoAbsen, set to null if not updated
        'PhotoAbsen': photoAbsen,
        // Always include PhotoPengamanan, set to null if not updated
        'PhotoPengamanan': photoPengamanan,
        if (photoPakaian != null) 'PhotoCheckoutPengamanan': photoPakaian,
        if (request.laporan != null && request.laporan!.isNotEmpty)
          'Laporan': request.laporan,
        if (request.laporanCheckout != null &&
            request.laporanCheckout!.isNotEmpty)
          'LaporanCheckout': request.laporanCheckout,
        if (request.isOvertime != null) 'IsOvertime': request.isOvertime,
        if (photoOvertime != null) 'PhotoOvertime': photoOvertime,
        // Token removed - already in Authorization header
      };

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
      
      if (payloadForLog['PhotoCheckoutPengamanan'] is Map) {
        final photoPakaianMap = Map<String, dynamic>.from(payloadForLog['PhotoCheckoutPengamanan'] as Map);
        if (photoPakaianMap['Base64'] is String) {
          final base64 = photoPakaianMap['Base64'] as String;
          photoPakaianMap['Base64'] = base64.length > 50 
              ? '${base64.substring(0, 50)}... (truncated, total length: ${base64.length})'
              : base64;
        }
        payloadForLog['PhotoCheckoutPengamanan'] = photoPakaianMap;
      }
      
      if (payloadForLog['PhotoOvertime'] is Map) {
        final photoOvertimeMap = Map<String, dynamic>.from(payloadForLog['PhotoOvertime'] as Map);
        if (photoOvertimeMap['Base64'] is String) {
          final base64 = photoOvertimeMap['Base64'] as String;
          photoOvertimeMap['Base64'] = base64.length > 50 
              ? '${base64.substring(0, 50)}... (truncated, total length: ${base64.length})'
              : base64;
        }
        payloadForLog['PhotoOvertime'] = photoOvertimeMap;
      }
      
      // Print formatted JSON
      final jsonEncoder = JsonEncoder.withIndent('  ');
      print(jsonEncoder.convert(payloadForLog));
      
      print('═══════════════════════════════════════════════════════════');
      // ========== LOGGING END ==========

      final response = await dio.post(
        '/Attendance/update',
        data: apiBody,
      );

      // ========== RESPONSE LOGGING ==========
      print('═══════════════════════════════════════════════════════════');
      print('✅ [Attendance/update] RESPONSE RECEIVED');
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

      // Handle response wrapper
      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;
        
        if (responseData.containsKey('Succeeded') &&
            responseData['Succeeded'] == true) {
          print('✅ [Attendance/update] SUCCESS');
          return; // Success
        } else {
          final errorMsg = responseData['Message'] ?? 'Failed to update attendance';
          print('❌ [Attendance/update] FAILED: $errorMsg');
          throw Exception(errorMsg);
        }
      }

      print('❌ [Attendance/update] Invalid response format');
      throw Exception('Invalid response format');
    } on DioException catch (e) {
      // ========== ERROR LOGGING ==========
      print('═══════════════════════════════════════════════════════════');
      print('❌ [Attendance/update] DIO EXCEPTION');
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
            'Failed to update attendance';
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
      
      if (e.response != null) {
        final errorMessage = e.response?.data['Message'] ??
            e.response?.data['Description'] ??
            'Failed to update attendance';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      // ========== GENERAL ERROR LOGGING ==========
      print('═══════════════════════════════════════════════════════════');
      print('❌ [Attendance/update] GENERAL EXCEPTION');
      print('═══════════════════════════════════════════════════════════');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      print('Stack Trace:');
      print(StackTrace.current);
      print('═══════════════════════════════════════════════════════════');
      // ========== GENERAL ERROR LOGGING END ==========
      
      throw Exception('Failed to update attendance: $e');
    }
  }

  Future<Map<String, dynamic>?> _encodePhoto(String? path) async {
    if (path == null || path.isEmpty) {
      print('⚠️ _encodePhoto: path is null or empty');
      return null;
    }
    
    try {
      print('📁 _encodePhoto: Starting encoding for path=$path');
      final file = File(path);
      
      // Check if file exists
      final exists = await file.exists();
      print('📁 _encodePhoto: File exists check: $exists');
      
      if (!exists) {
        print('❌ _encodePhoto: File does not exist at path: $path');
        print('❌ _encodePhoto: Attempting to check file permissions...');
        try {
          final parentDir = file.parent;
          final parentExists = await parentDir.exists();
          print('📁 _encodePhoto: Parent directory exists: $parentExists, path=${parentDir.path}');
        } catch (e) {
          print('❌ _encodePhoto: Error checking parent directory: $e');
        }
        return null;
      }
      
      // Get file size before reading
      final fileSize = await file.length();
      print('📁 _encodePhoto: File size: $fileSize bytes');
      
      if (fileSize == 0) {
        print('❌ _encodePhoto: File is empty (0 bytes)');
        return null;
      }
      
      // Read file bytes
      print('📁 _encodePhoto: Reading file bytes...');
      final bytes = await file.readAsBytes();
      print('✅ _encodePhoto: File read successfully, bytes.length=${bytes.length}, fileSize=$fileSize');
      
      if (bytes.isEmpty) {
        print('❌ _encodePhoto: Read bytes is empty');
        return null;
      }
      
      // Encode to base64
      print('📁 _encodePhoto: Encoding to base64...');
      final base64Str = base64Encode(bytes);
      print('✅ _encodePhoto: Base64 encoded, length=${base64Str.length}');
      
      // Extract filename and extension
      final filename = path.split(RegExp(r'[\/\\]')).last;
      final ext = filename.contains('.')
          ? filename.split('.').last.toLowerCase()
          : '';
      final mime = _guessMimeType(ext);
      
      print('📁 _encodePhoto: Filename=$filename, Extension=$ext, MimeType=$mime');
      
      final result = {
        'Filename': filename,
        'MimeType': mime,
        'Base64': base64Str,
      };
      
      print('✅ _encodePhoto: Successfully encoded, filename=$filename, mime=$mime, base64Length=${base64Str.length}');
      return result;
    } catch (e, stackTrace) {
      print('❌ _encodePhoto: Error encoding photo at path $path');
      print('❌ _encodePhoto: Error: $e');
      print('❌ _encodePhoto: Stack trace: $stackTrace');
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


}

