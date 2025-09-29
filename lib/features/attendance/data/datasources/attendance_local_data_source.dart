import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';
import 'dart:convert';
import '../models/attendance_model.dart';

abstract class AttendanceLocalDataSource {
  Future<List<AttendanceModel>> getCachedAttendanceHistory();
  Future<void> cacheAttendanceHistory(List<AttendanceModel> attendanceList);
  Future<AttendanceModel?> getLastAttendance();
  Future<void> cacheLastAttendance(AttendanceModel attendance);
  Future<void> clearCache();
}

@LazySingleton(as: AttendanceLocalDataSource)
class AttendanceLocalDataSourceImpl implements AttendanceLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String cachedAttendanceHistoryKey = 'CACHED_ATTENDANCE_HISTORY';
  static const String lastAttendanceKey = 'LAST_ATTENDANCE';

  AttendanceLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<AttendanceModel>> getCachedAttendanceHistory() async {
    final jsonString = sharedPreferences.getString(cachedAttendanceHistoryKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => AttendanceModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> cacheAttendanceHistory(
      List<AttendanceModel> attendanceList) async {
    final List<Map<String, dynamic>> jsonList =
        attendanceList.map((attendance) => attendance.toJson()).toList();

    await sharedPreferences.setString(
      cachedAttendanceHistoryKey,
      json.encode(jsonList),
    );
  }

  @override
  Future<AttendanceModel?> getLastAttendance() async {
    final jsonString = sharedPreferences.getString(lastAttendanceKey);
    if (jsonString != null) {
      return AttendanceModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheLastAttendance(AttendanceModel attendance) async {
    await sharedPreferences.setString(
      lastAttendanceKey,
      json.encode(attendance.toJson()),
    );
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(cachedAttendanceHistoryKey);
    await sharedPreferences.remove(lastAttendanceKey);
  }
}
