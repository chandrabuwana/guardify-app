import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/shift_schedule.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../datasources/schedule_remote_data_source.dart';
import '../models/shift_schedule_model.dart';
import '../models/shift_category_response_model.dart';
import '../models/route_response_model.dart';
import '../models/schedule_detail_response_model.dart';
import '../models/current_shift_response_model.dart';

@LazySingleton(as: ScheduleRepository)
class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  // Cache untuk ShiftCategory (key: idShiftCategory, value: ShiftCategoryModel)
  final Map<int, ShiftCategoryModel> _shiftCategoryCache = {};

  // Cache untuk Route (key: idRoute, value: RouteDataModel)
  final Map<String, RouteDataModel> _routeCache = {};

  ScheduleRepositoryImpl({required this.remoteDataSource});

  /// Fetch shift category by ID dengan caching
  Future<ShiftCategoryModel?> _getShiftCategory(int idShiftCategory) async {
    // Check cache first
    if (_shiftCategoryCache.containsKey(idShiftCategory)) {
      print(
          '[ScheduleRepository] 📦 Cache hit for shift category $idShiftCategory');
      return _shiftCategoryCache[idShiftCategory];
    }

    try {
      print(
          '[ScheduleRepository] 🔍 Fetching shift category $idShiftCategory from API...');

      final requestBody = {
        'Filter': [
          {'Field': 'Id', 'Search': idShiftCategory.toString()},
        ],
        'Sort': {'Field': '', 'Type': 0},
        'Start': 0,
        'Length': 1,
      };

      final response = await remoteDataSource.getShiftCategories(requestBody);

      if (response.succeeded && response.list.isNotEmpty) {
        final category = response.list.first;
        _shiftCategoryCache[idShiftCategory] = category;

        print(
            '[ScheduleRepository] ✅ Shift category loaded: ${category.name} (${category.startTime} - ${category.endTime})');
        return category;
      }

      print(
          '[ScheduleRepository] ⚠️ Shift category $idShiftCategory not found');
      return null;
    } catch (e) {
      print('[ScheduleRepository] ❌ Error fetching shift category: $e');
      return null;
    }
  }

  /// Fetch route by ID dengan caching
  Future<RouteDataModel?> _getRoute(String idRoute) async {
    // Check cache first
    if (_routeCache.containsKey(idRoute)) {
      print('[ScheduleRepository] 📦 Cache hit for route $idRoute');
      return _routeCache[idRoute];
    }

    try {
      print('[ScheduleRepository] 🔍 Fetching route $idRoute from API...');

      final response = await remoteDataSource.getRouteById(idRoute);

      if (response.succeeded && response.data != null) {
        final route = response.data!;
        _routeCache[idRoute] = route;

        print('[ScheduleRepository] ✅ Route loaded: ${route.name}');
        return route;
      }

      print('[ScheduleRepository] ⚠️ Route $idRoute not found');
      return null;
    } catch (e) {
      print('[ScheduleRepository] ❌ Error fetching route: $e');
      return null;
    }
  }

  /// Helper to build request body for API
  Map<String, dynamic> _buildRequestBody({
    required String userId,
    required String dateFilter,
  }) {
    return {
      'Filter': [
        {'Field': 'jadwal', 'Search': dateFilter},
        {'Field': 'UserId', 'Search': userId},
      ],
      'Sort': {'Field': '', 'Type': 0},
      'Start': 0,
      'Length': 0, // 0 = fetch all
    };
  }

  @override
  Future<ScheduleResult> getMonthlySchedule({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      print('[ScheduleRepository] Fetching monthly schedule for $year-$month');

      // Get all days in the month
      final daysInMonth = DateTime(year, month + 1, 0).day;
      final allSchedules = <ShiftScheduleModel>[];
      final uniqueShiftCategories = <int>{};

      // Fetch schedule for each day in the month
      for (int day = 1; day <= daysInMonth; day++) {
        final date = DateTime(year, month, day);
        final dateString = DateFormat('yyyy-MM-dd').format(date);

        final requestBody = _buildRequestBody(
          userId: userId,
          dateFilter: dateString,
        );

        try {
          final response =
              await remoteDataSource.getShiftDetailsByDate(requestBody);

          if (response.succeeded && response.list.isNotEmpty) {
            // Collect unique shift category IDs
            for (var item in response.list) {
              uniqueShiftCategories.add(item.shift.idShiftCategory);
            }

            // Group by shift ID to avoid duplicates
            final uniqueShifts = <String, ShiftScheduleModel>{};
            for (var item in response.list) {
              if (!uniqueShifts.containsKey(item.idShift)) {
                // Fetch shift category untuk item ini
                final shiftCategory =
                    await _getShiftCategory(item.shift.idShiftCategory);

                uniqueShifts[item.idShift] = item.toShiftScheduleModel(
                  response.list,
                  shiftCategory: shiftCategory,
                );
              }
            }
            allSchedules.addAll(uniqueShifts.values);
          }
        } catch (e) {
          print('[ScheduleRepository] Error fetching day $day: $e');
          // Continue to next day
        }
      }

      final schedules = allSchedules.map((model) => model.toEntity()).toList();

      print(
          '[ScheduleRepository] ✅ Found ${schedules.length} schedules for $year-$month (${uniqueShiftCategories.length} unique shift types)');
      return ScheduleResult.success(schedules);
    } on DioException catch (e) {
      print('[ScheduleRepository] ❌ DioException: ${e.message}');
      if (e.response?.statusCode != null &&
          e.response!.statusCode! >= 400 &&
          e.response!.statusCode! < 500) {
        return ScheduleResult.failure(
          AuthenticationFailure('Gagal memuat jadwal'),
        );
      }
      return ScheduleResult.failure(
        ServerFailure('Terjadi kesalahan pada server'),
      );
    } catch (e) {
      print('[ScheduleRepository] ❌ Error: $e');
      return ScheduleResult.failure(
        UnexpectedFailure(e.toString()),
      );
    }
  }

  @override
  Future<ShiftDetailResult> getShiftDetail({
    required String userId,
    required DateTime date,
  }) async {
    try {
      print('[ScheduleRepository] Fetching shift detail for $date');

      final dateString = DateFormat('yyyy-MM-dd').format(date);
      final requestBody = _buildRequestBody(
        userId: userId,
        dateFilter: dateString,
      );

      final response =
          await remoteDataSource.getShiftDetailsByDate(requestBody);

      if (!response.succeeded || response.list.isEmpty) {
        print('[ScheduleRepository] ❌ No shift found for date');
        return ShiftDetailResult.failure(
          CacheFailure('Tidak ada shift untuk tanggal ini'),
        );
      }

      // Fetch ShiftCategory untuk mendapatkan nama & waktu shift yang akurat
      final idShiftCategory = response.list.first.shift.idShiftCategory;
      final shiftCategory = await _getShiftCategory(idShiftCategory);

      if (shiftCategory != null) {
        print(
            '[ScheduleRepository] 📋 Using shift category: ${shiftCategory.name}');
      } else {
        print(
            '[ScheduleRepository] ⚠️ Shift category not found, using fallback logic');
      }

      // Fetch Route untuk mendapatkan nama rute yang akurat
      RouteDataModel? routeData;
      final idRoute = response.list.first.idRoute;
      if (idRoute != null && idRoute.isNotEmpty) {
        routeData = await _getRoute(idRoute);

        if (routeData != null) {
          print('[ScheduleRepository] 🗺️ Using route: ${routeData.name}');
        } else {
          print('[ScheduleRepository] ⚠️ Route not found, using fallback');
        }
      }

      // Convert first item to ShiftScheduleModel (with all team members + shift category + route)
      final shiftModel = response.list.first.toShiftScheduleModel(
        response.list,
        shiftCategory: shiftCategory,
        routeData: routeData,
      );
      final shiftDetail = shiftModel.toEntity();

      print(
          '[ScheduleRepository] ✅ Found shift detail with ${response.list.length} members');
      return ShiftDetailResult.success(shiftDetail);
    } on DioException catch (e) {
      print('[ScheduleRepository] ❌ DioException: ${e.message}');
      if (e.response?.statusCode != null &&
          e.response!.statusCode! >= 400 &&
          e.response!.statusCode! < 500) {
        return ShiftDetailResult.failure(
          AuthenticationFailure('Gagal memuat detail shift'),
        );
      }
      return ShiftDetailResult.failure(
        ServerFailure('Terjadi kesalahan pada server'),
      );
    } catch (e) {
      print('[ScheduleRepository] ❌ Error: $e');
      return ShiftDetailResult.failure(
        UnexpectedFailure(e.toString()),
      );
    }
  }

  @override
  Future<DailyAgendaResult> getDailyAgenda({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      print(
          '[ScheduleRepository] 📅 Fetching daily agenda for $userId - $year-$month');

      // Fetch ALL shifts for the user in one API call
      // API will return only shifts that exist for this user
      final requestBody = {
        'Filter': [
          {'Field': 'UserId', 'Search': userId},
        ],
        'Sort': {'Field': 'CreateDate', 'Type': 1},
        'Start': 0,
        'Length': 0, // 0 = fetch all
      };

      print('[ScheduleRepository] 🔍 Fetching all shifts for user $userId...');
      final response =
          await remoteDataSource.getShiftDetailsByDate(requestBody);

      print(
          '[ScheduleRepository] Response - Succeeded: ${response.succeeded}, Total shifts: ${response.list.length}');

      if (!response.succeeded) {
        return DailyAgendaResult.failure(
          ServerFailure('Gagal mengambil data jadwal'),
        );
      }

      final agendas = <DailyAgenda>[];

      // Map API response to DailyAgenda entities
      // Only include shifts that match the requested year-month
      for (final item in response.list) {
        // Parse ShiftDate string to DateTime
        final shiftDate = DateTime.parse(item.shift.shiftDate);

        // Filter by year and month
        if (shiftDate.year == year && shiftDate.month == month) {
          // Tentukan shift type berdasarkan JAM di ShiftDate
          // Shift Pagi: 07:00 - 19:00 (hour >= 7 && hour < 19)
          // Shift Malam: 19:00 - 07:00 (hour >= 19 || hour < 7)
          final hour = shiftDate.hour;
          final shiftType = (hour >= 7 && hour < 19) ? 'Pagi' : 'Malam';

          print(
              '[ScheduleRepository] ✅ Shift found: $shiftType (hour: $hour) at ${item.location} on ${DateFormat('yyyy-MM-dd').format(shiftDate)}');

          agendas.add(DailyAgenda(
            date: shiftDate,
            shiftType: shiftType,
            position: item.location,
          ));
        }
      }

      print(
          '[ScheduleRepository] ✅ Found ${agendas.length} agenda items for $year-$month');

      return DailyAgendaResult.success(agendas);
    } on DioException catch (e) {
      print('[ScheduleRepository] ❌ DioException: ${e.message}');
      if (e.response?.statusCode != null &&
          e.response!.statusCode! >= 400 &&
          e.response!.statusCode! < 500) {
        return DailyAgendaResult.failure(
          AuthenticationFailure('Gagal memuat agenda'),
        );
      }
      return DailyAgendaResult.failure(
        ServerFailure('Terjadi kesalahan pada server'),
      );
    } catch (e) {
      print('[ScheduleRepository] ❌ Error: $e');
      return DailyAgendaResult.failure(
        UnexpectedFailure(e.toString()),
      );
    }
  }

  @override
  Future<ShiftDetailResult> getScheduleDetail({
    required String userId,
    required DateTime date,
  }) async {
    try {
      print('[ScheduleRepository] Fetching schedule detail for $date using get_detail_schedule API');

      final dateString = DateFormat('yyyy-MM-dd').format(date);
      final requestBody = {
        'ShiftDate': dateString,
        'IdUser': userId,
      };

      final response = await remoteDataSource.getDetailSchedule(requestBody);

      // Handle case when API returns no data (Code 400, Data null)
      // This is a valid response - just means no schedule for this date
      if (!response.succeeded || response.data == null) {
        print('[ScheduleRepository] ℹ️ No schedule detail found for date (this is normal)');
        // Return success with null data to show empty state instead of error
        return ShiftDetailResult.success(null);
      }

      // Convert to ShiftScheduleModel and then to entity
      final shiftModel = response.data!.toShiftScheduleModel(date);
      final shiftDetail = shiftModel.toEntity();

      print('[ScheduleRepository] ✅ Found schedule detail: ${shiftDetail.shiftName}');
      return ShiftDetailResult.success(shiftDetail);
    } on DioException catch (e) {
      print('[ScheduleRepository] ❌ DioException: ${e.message}');
      if (e.response?.statusCode != null &&
          e.response!.statusCode! >= 400 &&
          e.response!.statusCode! < 500) {
        return ShiftDetailResult.failure(
          AuthenticationFailure('Gagal memuat detail jadwal'),
        );
      }
      return ShiftDetailResult.failure(
        ServerFailure('Terjadi kesalahan pada server'),
      );
    } catch (e) {
      print('[ScheduleRepository] ❌ Error: $e');
      return ShiftDetailResult.failure(
        UnexpectedFailure(e.toString()),
      );
    }
  }

  @override
  Future<CurrentShiftResult> getCurrentShift({
    required String userId,
  }) async {
    try {
      print('[ScheduleRepository] Fetching current shift for user $userId');

      final requestBody = {
        'IdUser': userId,
      };

      final response = await remoteDataSource.getCurrentShift(requestBody);

      if (!response.succeeded || response.data == null) {
        print('[ScheduleRepository] ❌ No current shift found');
        return CurrentShiftResult.failure(
          CacheFailure('Tidak ada shift saat ini'),
        );
      }

      // Convert to entity
      final currentShift = CurrentShiftData(
        id: response.data!.id,
        name: response.data!.name,
        startTime: response.data!.startTime,
        checkin: response.data!.checkin,
        checkout: response.data!.checkout,
        checkinTime: response.data!.checkinTime,
        checkoutTime: response.data!.checkoutTime,
        listPersonel: response.data!.listPersonel.map((p) {
          return CurrentShiftPersonnel(
            userId: p.userId,
            fullname: p.fullname,
            images: p.images,
          );
        }).toList(),
      );

      print('[ScheduleRepository] ✅ Found current shift: ${currentShift.name}');
      return CurrentShiftResult.success(currentShift);
    } on DioException catch (e) {
      print('[ScheduleRepository] ❌ DioException: ${e.message}');
      if (e.response?.statusCode != null &&
          e.response!.statusCode! >= 400 &&
          e.response!.statusCode! < 500) {
        return CurrentShiftResult.failure(
          AuthenticationFailure('Gagal memuat shift saat ini'),
        );
      }
      return CurrentShiftResult.failure(
        ServerFailure('Terjadi kesalahan pada server'),
      );
    } catch (e) {
      print('[ScheduleRepository] ❌ Error: $e');
      return CurrentShiftResult.failure(
        UnexpectedFailure(e.toString()),
      );
    }
  }
}
