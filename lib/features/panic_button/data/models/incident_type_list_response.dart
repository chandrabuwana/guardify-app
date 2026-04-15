import 'package:json_annotation/json_annotation.dart';
import 'panic_button_incident_type_model.dart';

part 'incident_type_list_response.g.dart';

/// Response model untuk IncidentType List API
@JsonSerializable()
class IncidentTypeListResponse {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<PanicButtonIncidentTypeModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  IncidentTypeListResponse({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory IncidentTypeListResponse.fromJson(Map<String, dynamic> json) =>
      _$IncidentTypeListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentTypeListResponseToJson(this);
}
