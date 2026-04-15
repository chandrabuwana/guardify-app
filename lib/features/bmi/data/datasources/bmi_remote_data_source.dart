import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/bmi_api_response_model.dart';

part 'bmi_remote_data_source.g.dart';

@RestApi()
abstract class BmiRemoteDataSource {
  factory BmiRemoteDataSource(Dio dio, {String baseUrl}) = _BmiRemoteDataSource;

  @POST('/Bmi/list')
  Future<BmiListResponseModel> getBmiList(
    @Body() BmiListRequestModel request,
  );

  @POST('/User/list')
  Future<UserListResponseModel> getUserList(
    @Body() UserListRequestModel request,
  );
}
