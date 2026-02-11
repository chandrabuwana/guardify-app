import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/login_response_model.dart';
import '../models/current_location_request_model.dart';
import '../models/current_location_response_model.dart';
import '../../../patrol/data/models/area_list_api_response.dart';
import '../../../patrol/data/models/route_detail_api_response.dart';

part 'auth_remote_data_source.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) =
      _AuthRemoteDataSource;

  @POST('/User/login')
  Future<LoginResponseModel> login(
    @Body() Map<String, dynamic> body,
  );

  @POST('/User/reset_password')
  Future<Map<String, dynamic>> resetPassword(
    @Body() Map<String, dynamic> body,
  );

  @POST('/CurrentLocation/employee')
  Future<CurrentLocationResponseModel> getEmployeeLocations(
    @Body() CurrentLocationRequestModel request,
  );

  @POST('/Areas/list')
  Future<AreaListResponse> getAreaList(
    @Body() AreaListRequest request,
  );
}
