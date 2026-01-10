import 'dart:convert';

/// Model untuk menyimpan log request dan response API
class ApiLogModel {
  final String id;
  final DateTime timestamp;
  final String method; // GET, POST, PUT, DELETE
  final String url;
  final Map<String, dynamic>? headers;
  final dynamic requestBody;
  final int? statusCode;
  final dynamic responseBody;
  final String? error;
  final int? durationMs; // Response time in milliseconds

  ApiLogModel({
    required this.id,
    required this.timestamp,
    required this.method,
    required this.url,
    this.headers,
    this.requestBody,
    this.statusCode,
    this.responseBody,
    this.error,
    this.durationMs,
  });

  /// Convert to JSON untuk disimpan ke SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'method': method,
      'url': url,
      'headers': headers,
      'requestBody': requestBody,
      'statusCode': statusCode,
      'responseBody': responseBody,
      'error': error,
      'durationMs': durationMs,
    };
  }

  /// Create from JSON
  factory ApiLogModel.fromJson(Map<String, dynamic> json) {
    return ApiLogModel(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      method: json['method'] as String,
      url: json['url'] as String,
      headers: json['headers'] as Map<String, dynamic>?,
      requestBody: json['requestBody'],
      statusCode: json['statusCode'] as int?,
      responseBody: json['responseBody'],
      error: json['error'] as String?,
      durationMs: json['durationMs'] as int?,
    );
  }

  /// Format log untuk ditampilkan atau di-copy
  String getFormattedLog() {
    final buffer = StringBuffer();
    buffer.writeln('=' * 80);
    buffer.writeln('API LOG - $timestamp');
    buffer.writeln('=' * 80);
    buffer.writeln('\n[REQUEST]');
    buffer.writeln('Method: $method');
    buffer.writeln('URL: $url');
    
    if (headers != null && headers!.isNotEmpty) {
      buffer.writeln('\nHeaders:');
      headers!.forEach((key, value) {
        // Hide sensitive information
        if (key.toLowerCase() == 'authorization') {
          buffer.writeln('  $key: Bearer ***');
        } else {
          final truncatedValue = _truncateLongValue(value);
          buffer.writeln('  $key: $truncatedValue');
        }
      });
    }
    
    if (requestBody != null) {
      buffer.writeln('\nRequest Body:');
      try {
        final truncatedBody = _truncateJsonValue(requestBody);
        final prettyJson = const JsonEncoder.withIndent('  ').convert(truncatedBody);
        buffer.writeln(prettyJson);
      } catch (e) {
        final truncatedBody = _truncateLongValue(requestBody.toString());
        buffer.writeln(truncatedBody);
      }
    }
    
    buffer.writeln('\n[RESPONSE]');
    if (error != null) {
      buffer.writeln('Error: $error');
    } else if (statusCode != null) {
      buffer.writeln('Status Code: $statusCode');
      if (durationMs != null) {
        buffer.writeln('Duration: ${durationMs}ms');
      }
      if (responseBody != null) {
        buffer.writeln('\nResponse Body:');
        try {
          final truncatedBody = _truncateJsonValue(responseBody);
          final prettyJson = const JsonEncoder.withIndent('  ').convert(truncatedBody);
          buffer.writeln(prettyJson);
        } catch (e) {
          final truncatedBody = _truncateLongValue(responseBody.toString());
          buffer.writeln(truncatedBody);
        }
      }
    }
    
    buffer.writeln('\n' + '=' * 80);
    return buffer.toString();
  }

  /// Truncate string panjang seperti base64 agar lebih mudah dibaca
  /// Maksimal panjang: 100 karakter
  static const int _maxStringLength = 100;

  String _truncateLongString(String value) {
    if (value.length <= _maxStringLength) {
      return value;
    }
    return '${value.substring(0, _maxStringLength)}... (truncated, length: ${value.length})';
  }

  /// Truncate value yang bisa berupa string atau tipe lain
  dynamic _truncateLongValue(dynamic value) {
    if (value is String) {
      return _truncateLongString(value);
    }
    return value;
  }

  /// Recursively truncate string panjang di dalam JSON structure
  dynamic _truncateJsonValue(dynamic value) {
    if (value is String) {
      return _truncateLongString(value);
    } else if (value is Map) {
      final truncatedMap = <String, dynamic>{};
      value.forEach((key, val) {
        truncatedMap[key.toString()] = _truncateJsonValue(val);
      });
      return truncatedMap;
    } else if (value is List) {
      return value.map((item) => _truncateJsonValue(item)).toList();
    } else {
      return value;
    }
  }

  /// Get summary untuk list view
  String getSummary() {
    final status = error != null 
        ? 'ERROR' 
        : statusCode != null 
            ? '${statusCode}' 
            : 'PENDING';
    final duration = durationMs != null ? ' (${durationMs}ms)' : '';
    return '$method $url - $status$duration';
  }
}

