import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../models/shift_detail_response_model.dart';
import '../models/shift_category_response_model.dart';
import '../models/route_response_model.dart';

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
}

/// Abstract interface for schedule remote data source
abstract class ScheduleRemoteDataSource {
  Future<ShiftDetailResponseModel> getShiftDetailsByDate(
      Map<String, dynamic> body);
  Future<ShiftCategoryResponseModel> getShiftCategories(
      Map<String, dynamic> body);
  Future<RouteResponseModel> getRouteById(String id);
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
}
