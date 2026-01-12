import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_log_model.dart';

/// Service untuk mengelola API logs (save, retrieve, clear)
@lazySingleton
class ApiLogService {
  final SharedPreferences _prefs;
  
  static const String _logsKey = 'api_logs';
  static const int _maxLogs = 100; // Maksimal 100 log entries

  ApiLogService(this._prefs);

  /// Simpan log baru
  Future<void> saveLog(ApiLogModel log) async {
    try {
      final logs = await getAllLogs();
      
      // Add new log di awal list (newest first)
      logs.insert(0, log);
      
      // Batasi jumlah log
      if (logs.length > _maxLogs) {
        logs.removeRange(_maxLogs, logs.length);
      }
      
      // Simpan ke SharedPreferences
      final logsJson = logs.map((log) => log.toJson()).toList();
      await _prefs.setString(_logsKey, json.encode(logsJson));
    } catch (e) {
      // Silent fail untuk logging service
      print('Error saving API log: $e');
    }
  }

  /// Ambil semua logs (sorted by timestamp, newest first)
  Future<List<ApiLogModel>> getAllLogs() async {
    try {
      final logsJsonString = _prefs.getString(_logsKey);
      if (logsJsonString == null || logsJsonString.isEmpty) {
        return [];
      }
      
      final List<dynamic> logsJson = json.decode(logsJsonString);
      return logsJson
          .map((json) => ApiLogModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting API logs: $e');
      return [];
    }
  }

  /// Clear semua logs
  Future<void> clearLogs() async {
    try {
      await _prefs.remove(_logsKey);
    } catch (e) {
      print('Error clearing API logs: $e');
    }
  }

  /// Get jumlah logs
  Future<int> getLogCount() async {
    final logs = await getAllLogs();
    return logs.length;
  }
}

