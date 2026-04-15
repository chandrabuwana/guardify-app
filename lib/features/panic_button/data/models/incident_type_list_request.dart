import 'package:json_annotation/json_annotation.dart';
import '../../../patrol/data/models/route_detail_api_response.dart';

part 'incident_type_list_request.g.dart';

/// Request model untuk IncidentType List API
@JsonSerializable()
class IncidentTypeListRequest {
  @JsonKey(name: 'Filter')
  final List<FilterModel> filter;

  @JsonKey(name: 'Sort')
  final SortModel sort;

  @JsonKey(name: 'Start')
  final int start;

  @JsonKey(name: 'Length')
  final int length;

  IncidentTypeListRequest({
    required this.filter,
    required this.sort,
    required this.start,
    required this.length,
  });

  factory IncidentTypeListRequest.fromJson(Map<String, dynamic> json) =>
      _$IncidentTypeListRequestFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentTypeListRequestToJson(this);
}
