import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/assessment_detail_response_model.dart';

part 'test_result_api_data_source.g.dart';

/// Retrofit API client untuk Test Result
@RestApi()
abstract class TestResultApiDataSource {
  factory TestResultApiDataSource(Dio dio, {String baseUrl}) =
      _TestResultApiDataSource;

  /// Fetch list assessment detail
  @POST('/AssesmentDetail/list')
  Future<AssessmentDetailResponseModel> fetchAssessmentDetails(
    @Body() Map<String, dynamic> body,
  );
}
