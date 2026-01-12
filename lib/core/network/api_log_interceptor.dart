import 'package:dio/dio.dart';
import '../models/api_log_model.dart';
import '../services/api_log_service.dart';

/// Custom interceptor untuk capture dan save API logs
class ApiLogInterceptor extends Interceptor {
  final ApiLogService _logService;

  ApiLogInterceptor(this._logService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Simpan start time untuk calculate duration
    options.extra['_log_start_time'] = DateTime.now();
    
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _saveLogFromResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _saveLogFromError(err);
    handler.next(err);
  }

  /// Save log dari successful response
  void _saveLogFromResponse(Response response) {
    try {
      final requestOptions = response.requestOptions;
      final startTime = requestOptions.extra['_log_start_time'] as DateTime?;
      final duration = startTime != null
          ? DateTime.now().difference(startTime).inMilliseconds
          : null;

      final log = ApiLogModel(
        id: DateTime.now().millisecondsSinceEpoch.toString() +
            '_${requestOptions.uri.path}',
        timestamp: DateTime.now(),
        method: requestOptions.method,
        url: '${requestOptions.baseUrl}${requestOptions.path}',
        headers: _sanitizeHeaders(requestOptions.headers),
        requestBody: requestOptions.data,
        statusCode: response.statusCode,
        responseBody: response.data,
        durationMs: duration,
      );

      _logService.saveLog(log);
    } catch (e) {
      // Silent fail untuk logging
      print('Error in API log interceptor (response): $e');
    }
  }

  /// Save log dari error response
  void _saveLogFromError(DioException err) {
    try {
      final requestOptions = err.requestOptions;
      final startTime = requestOptions.extra['_log_start_time'] as DateTime?;
      final duration = startTime != null
          ? DateTime.now().difference(startTime).inMilliseconds
          : null;

      final log = ApiLogModel(
        id: DateTime.now().millisecondsSinceEpoch.toString() +
            '_${requestOptions.uri.path}',
        timestamp: DateTime.now(),
        method: requestOptions.method,
        url: '${requestOptions.baseUrl}${requestOptions.path}',
        headers: _sanitizeHeaders(requestOptions.headers),
        requestBody: requestOptions.data,
        statusCode: err.response?.statusCode,
        responseBody: err.response?.data,
        error: err.message,
        durationMs: duration,
      );

      _logService.saveLog(log);
    } catch (e) {
      // Silent fail untuk logging
      print('Error in API log interceptor (error): $e');
    }
  }

  /// Sanitize headers untuk remove sensitive data jika perlu
  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = Map<String, dynamic>.from(headers);
    // Keep headers as is, we'll handle masking in the display
    return sanitized;
  }
}

