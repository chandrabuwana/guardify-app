import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/incident_request_model.dart';
import '../models/panic_button_list_request.dart';
import '../models/panic_button_list_response.dart';
import '../models/panic_button_detail_response.dart';
import '../models/panic_button_submit_request.dart';
import '../models/panic_button_submit_response.dart';
import '../models/incident_type_list_request.dart';
import '../models/incident_type_list_response.dart';

part 'panic_button_remote_data_source.g.dart';

@RestApi()
abstract class PanicButtonApiClient {
  factory PanicButtonApiClient(Dio dio, {String baseUrl}) = _PanicButtonApiClient;

  @POST('/PanicButton/add')
  @DioResponseType(ResponseType.json)
  Future<dynamic> submitIncident(
    @Body() IncidentRequestModel request,
  );

  @POST('/PanicButton/list')
  Future<PanicButtonListResponse> getPanicButtonList(
    @Body() PanicButtonListRequest request,
  );

  @GET('/PanicButton/get/{id}')
  Future<PanicButtonDetailResponse> getPanicButtonDetail(
    @Path('id') String id,
  );

  @POST('/PanicButton/submit')
  Future<PanicButtonSubmitResponse> submitPanicButton(
    @Body() PanicButtonSubmitRequest request,
  );

  @POST('/IncidentType/list')
  Future<IncidentTypeListResponse> getIncidentTypes(
    @Body() IncidentTypeListRequest request,
  );
}

