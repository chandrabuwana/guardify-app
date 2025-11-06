import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:injectable/injectable.dart';
import '../models/personnel_list_response_model.dart';

part 'personnel_remote_data_source.g.dart';

/// Personnel Remote Data Source - Retrofit API Implementation
///
/// Endpoints:
/// - POST /User/list - Get paginated list of personnel with filters
/// - GET /User/{id} - Get personnel detail by ID
@RestApi()
@lazySingleton
abstract class PersonnelRemoteDataSource {
  @factoryMethod
  factory PersonnelRemoteDataSource(Dio dio) = _PersonnelRemoteDataSource;

  /// Get paginated list of personnel with filters
  ///
  /// Request body:
  /// `json
  /// {
  ///   \"Filter\": [{\"Field\": \"Status\", \"Search\": \"Active\"}],
  ///   \"Sort\": {\"Field\": \"\", \"Type\": 0},
  ///   \"Start\": 0,
  ///   \"Length\": 20
  /// }
  /// `
  @POST('/User/list')
  Future<PersonnelListResponseModel> getPersonnelList(
      @Body() Map<String, dynamic> body);

  /// Get personnel detail by ID
  @GET('/User/get/{id}')
  Future<PersonnelDetailResponseModel> getPersonnelById(
      @Path('id') String personnelId);

  /// Edit/Update user info (for approval with feedback and status change)
  @POST('/User/edit_info')
  Future<HttpResponse<dynamic>> editUserInfo(@Body() Map<String, dynamic> body);
}
