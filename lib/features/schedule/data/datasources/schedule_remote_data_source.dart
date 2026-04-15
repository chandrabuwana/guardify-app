import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../models/shift_detail_response_model.dart';
import '../models/shift_category_response_model.dart';
import '../models/route_response_model.dart';
import '../models/schedule_detail_response_model.dart';
import '../models/current_shift_response_model.dart';
import '../models/current_task_response_model.dart';
import '../models/schedule_pengawas_response_model.dart';
import '../models/shift_now_response_model.dart';

part 'schedule_remote_data_source.g.dart';

/// Retrofit API client for schedule endpoints
@RestApi()
abstract class ScheduleApiClient {
  factory ScheduleApiClient(Dio dio, {String baseUrl}) = _ScheduleApiClient;

  /// Get shift details by date using POST /ShiftDetail/list
  @POST('/ShiftDetail/list')
  Future<ShiftDetailResponseModel> getShiftDetailsByDate(
    @Body() Map<String, dynamic> body,
  );

  /// Get shift categories using POST /ShiftCategory/list
  @POST('/ShiftCategory/list')
  Future<ShiftCategoryResponseModel> getShiftCategories(
    @Body() Map<String, dynamic> body,
  );

  /// Get route by ID using GET /Route/get/{id}
  @GET('/Route/get/{id}')
  Future<RouteResponseModel> getRouteById(
    @Path('id') String id,
  );

  /// Get schedule detail using POST /Shift/get_detail_schedule
  @POST('/Shift/get_detail_schedule')
  Future<ScheduleDetailResponseModel> getDetailSchedule(
    @Body() Map<String, dynamic> body,
  );

  /// Get current shift using POST /Shift/get_current
  @POST('/Shift/get_current')
  Future<CurrentShiftResponseModel> getCurrentShift(
    @Body() Map<String, dynamic> body,
  );

  /// Get current task using POST /Shift/get_current_task
  @POST('/Shift/get_current_task')
  Future<CurrentTaskResponseModel> getCurrentTask(
    @Body() Map<String, dynamic> body,
  );

  /// Get schedule pengawas using POST /Shift/get_schedule_pengawas
  @POST('/Shift/get_schedule_pengawas')
  Future<SchedulePengawasResponseModel> getSchedulePengawas(
    @Body() Map<String, dynamic> body,
  );

  /// Get shift now using POST /Shift/get_shift_now
  @POST('/Shift/get_shift_now')
  Future<ShiftNowResponseModel> getShiftNow(
    @Body() Map<String, dynamic> body,
  );
}

/// Abstract interface for schedule remote data source
abstract class ScheduleRemoteDataSource {
  Future<ShiftDetailResponseModel> getShiftDetailsByDate(
      Map<String, dynamic> body);
  Future<ShiftCategoryResponseModel> getShiftCategories(
      Map<String, dynamic> body);
  Future<RouteResponseModel> getRouteById(String id);
  Future<ScheduleDetailResponseModel> getDetailSchedule(
      Map<String, dynamic> body);
  Future<CurrentShiftResponseModel> getCurrentShift(
      Map<String, dynamic> body);
  Future<CurrentTaskResponseModel> getCurrentTask(
    Map<String, dynamic> body);
  Future<SchedulePengawasResponseModel> getSchedulePengawas(
    Map<String, dynamic> body);
  Future<ShiftNowResponseModel> getShiftNow(
    Map<String, dynamic> body);
}

/// Implementation of ScheduleRemoteDataSource using Retrofit API client
@LazySingleton(as: ScheduleRemoteDataSource)
class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final ScheduleApiClient apiClient;

  ScheduleRemoteDataSourceImpl(Dio dio) : apiClient = ScheduleApiClient(dio);

  @override
  Future<ShiftDetailResponseModel> getShiftDetailsByDate(
      Map<String, dynamic> body) {
    return apiClient.getShiftDetailsByDate(body);
  }

  @override
  Future<ShiftCategoryResponseModel> getShiftCategories(
      Map<String, dynamic> body) {
    return apiClient.getShiftCategories(body);
  }

  @override
  Future<RouteResponseModel> getRouteById(String id) {
    return apiClient.getRouteById(id);
  }

  @override
  Future<ScheduleDetailResponseModel> getDetailSchedule(
      Map<String, dynamic> body) {
    return apiClient.getDetailSchedule(body);
  }

  @override
  Future<CurrentShiftResponseModel> getCurrentShift(
    Map<String, dynamic> body) {
    return apiClient.getCurrentShift(body);
  }

  @override
  Future<CurrentTaskResponseModel> getCurrentTask(
    Map<String, dynamic> body) {
    return apiClient.getCurrentTask(body);
  }

  @override
  Future<SchedulePengawasResponseModel> getSchedulePengawas(
    Map<String, dynamic> body) {
    return apiClient.getSchedulePengawas(body);
  }

  @override
  Future<ShiftNowResponseModel> getShiftNow(
    Map<String, dynamic> body) {
    return apiClient.getShiftNow(body);
  }
}
