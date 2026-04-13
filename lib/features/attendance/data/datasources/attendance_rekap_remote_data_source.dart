import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/image_compress_util.dart';
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
        
        final succeeded = responseData['Succeeded'] == true;
        if (succeeded) {
          return AttendanceRekapResponseModel.fromJson(responseData);
        }

        // Backend may return 404 Not Found as a valid "empty" result
        final code = responseData['Code'];
        final message = (responseData['Message'] ?? '').toString();
        final isNotFound = code == 404 || message.toLowerCase() == 'not found';
        if (isNotFound) {
          return const AttendanceRekapResponseModel(
            count: 0,
            filtered: 0,
            list: <AttendanceRekapItemModel>[],
            code: 404,
            succeeded: false,
            message: 'Not Found',
            description: null,
          );
        }

        throw Exception(
            responseData['Message'] ?? 'Failed to get attendance recap');
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 503) {
        throw Exception('Server sedang maintenance. Silakan coba lagi nanti.');
      }

      if (e.response != null) {
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          final errorMessage =
              data['Message'] ?? data['Description'] ?? 'Failed to get attendance recap';
          throw Exception(errorMessage);
        }

        if (data is String && data.trim().isNotEmpty) {
          throw Exception('Failed to get attendance recap (${statusCode ?? 'unknown'})');
        }

        throw Exception('Failed to get attendance recap (${statusCode ?? 'unknown'})');
      }

      throw Exception('Network error: ${e.message}');
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
      final statusCode = e.response?.statusCode;
      if (statusCode == 503) {
        throw Exception('Server sedang maintenance. Silakan coba lagi nanti.');
      }

      if (e.response != null) {
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          final errorMessage = data['Message'] ??
              data['Description'] ??
              'Failed to get attendance recap detail';
          throw Exception(errorMessage);
        }

        if (data is String && data.trim().isNotEmpty) {
          throw Exception(
              'Failed to get attendance recap detail (${statusCode ?? 'unknown'})');
        }

        throw Exception(
            'Failed to get attendance recap detail (${statusCode ?? 'unknown'})');
      }

      throw Exception('Network error: ${e.message}');
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
      print(
          '  photoPengamananCheckOutPath: ${request.photoPengamananCheckOutPath ?? "null"}');
      print('  photoOvertimePath: ${request.photoOvertimePath ?? "null"}');

      final photoPakaianCheckIn = await _encodePhoto(
        request.photoAbsenPath,
        filenameOverride: request.photoAbsenFilename,
      );
      final photoPengamananCheckIn =
          await _encodePhoto(
        request.photoPengamananPath,
        filenameOverride: request.photoPengamananFilename,
      );
      final photoAbsenCheckOut = await _encodePhoto(
        request.photoPakaianPath,
        filenameOverride: request.photoPakaianFilename,
      );
      final photoPengamananCheckOut =
          await _encodePhoto(
        request.photoPengamananCheckOutPath,
        filenameOverride: request.photoPengamananCheckOutFilename,
      );
      final photoLemburCheckOut = await _encodePhoto(
        request.photoOvertimePath,
        filenameOverride: request.photoOvertimeFilename,
      );

      // Log encoded photos summary
      print('📸 Encoded Photos Summary:');
      print(
          '  photoPakaianCheckIn: ${photoPakaianCheckIn != null ? "✅ encoded (${photoPakaianCheckIn['Filename']}, ${photoPakaianCheckIn['MimeType']}, base64Length: ${(photoPakaianCheckIn['Base64'] as String).length})" : "❌ null"}');
      print(
          '  photoPengamananCheckIn: ${photoPengamananCheckIn != null ? "✅ encoded (${photoPengamananCheckIn['Filename']}, ${photoPengamananCheckIn['MimeType']}, base64Length: ${(photoPengamananCheckIn['Base64'] as String).length})" : "❌ null"}');
      print(
          '  photoAbsenCheckOut: ${photoAbsenCheckOut != null ? "✅ encoded (${photoAbsenCheckOut['Filename']}, ${photoAbsenCheckOut['MimeType']}, base64Length: ${(photoAbsenCheckOut['Base64'] as String).length})" : "❌ null"}');
      print(
          '  photoPengamananCheckOut: ${photoPengamananCheckOut != null ? "✅ encoded (${photoPengamananCheckOut['Filename']}, ${photoPengamananCheckOut['MimeType']}, base64Length: ${(photoPengamananCheckOut['Base64'] as String).length})" : "❌ null"}');
      print(
          '  photoLemburCheckOut: ${photoLemburCheckOut != null ? "✅ encoded (${photoLemburCheckOut['Filename']}, ${photoLemburCheckOut['MimeType']}, base64Length: ${(photoLemburCheckOut['Base64'] as String).length})" : "❌ null"}');

      final Map<String, dynamic> apiBody = {
        'IdAttendance': request.idAttendance,
        if (photoPakaianCheckIn != null)
          'PhotoPakaianCheckIn': photoPakaianCheckIn,
        if (photoPengamananCheckIn != null)
          'PhotoPengamananCheckIn': photoPengamananCheckIn,
        if (photoAbsenCheckOut != null) 'PhotoAbsenCheckOut': photoAbsenCheckOut,
        if (photoPengamananCheckOut != null)
          'PhotoPengamananCheckOut': photoPengamananCheckOut,
        if (photoLemburCheckOut != null)
          'PhotoLemburCheckOut': photoLemburCheckOut,
        if (request.laporan != null && request.laporan!.isNotEmpty)
          'Laporan': request.laporan,
        if (request.laporanCheckout != null &&
            request.laporanCheckout!.isNotEmpty)
          'LaporanCheckout': request.laporanCheckout,
        if (request.isOvertime != null) 'IsOvertime': request.isOvertime,
        // Token removed - already in Authorization header
      };

      // Log full payload (with base64 truncated for readability)
      print('📦 Full Payload:');
      final payloadForLog = Map<String, dynamic>.from(apiBody);
      
      // Truncate base64 strings for logging (show first 50 chars)
      void _truncatePhotoField(String key) {
        if (payloadForLog[key] is Map) {
          final map = Map<String, dynamic>.from(payloadForLog[key] as Map);
          if (map['Base64'] is String) {
            final base64 = map['Base64'] as String;
            if (base64.length > 80) {
              final head = base64.substring(0, 40);
              final tail = base64.substring(base64.length - 40);
              map['Base64'] = '$head...$tail (truncated, total length: ${base64.length})';
            } else {
              map['Base64'] = base64;
            }
          }
          payloadForLog[key] = map;
        }
      }

      _truncatePhotoField('PhotoPakaianCheckIn');
      _truncatePhotoField('PhotoPengamananCheckIn');
      _truncatePhotoField('PhotoAbsenCheckOut');
      _truncatePhotoField('PhotoPengamananCheckOut');
      _truncatePhotoField('PhotoLemburCheckOut');
      
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

  Future<Map<String, dynamic>?> _encodePhoto(
    String? path, {
    String? filenameOverride,
  }) async {
    if (path == null || path.isEmpty) {
      print('⚠️ _encodePhoto: path is null or empty');
      return null;
    }
    
    try {
      print('📁 _encodePhoto: Starting encoding for path=$path');
      final file = await ImageCompressUtil.ensureMax1MbIfImage(path);
      
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
      final inferredFilename = path.split(RegExp(r'[\/\\]')).last;
      final filename = (filenameOverride != null && filenameOverride.isNotEmpty)
          ? filenameOverride
          : inferredFilename;
      final ext = filename.contains('.') ? filename.split('.').last.toLowerCase() : '';
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

