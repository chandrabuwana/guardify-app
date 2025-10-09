import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/login_response_model.dart';

part 'auth_remote_data_source.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) =
      _AuthRemoteDataSource;

  @POST('/User/login')
  Future<LoginResponseModel> login(
    @Body() Map<String, dynamic> body,
  );
}
