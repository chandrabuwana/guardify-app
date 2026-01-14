import 'package:json_annotation/json_annotation.dart';
import '../../../patrol/data/models/route_detail_api_response.dart'; // Import FilterModel and SortModel

part 'incident_type_list_api_response.g.dart';

/// Response model untuk IncidentType List API
@JsonSerializable()
class IncidentTypeListResponse {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<IncidentTypeApiModel> list;

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

/// Model untuk IncidentType dari API
@JsonSerializable()
class IncidentTypeApiModel {
  @JsonKey(name: 'Id')
  final int id;

  @JsonKey(name: 'Active')
  final bool active;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final DateTime? createDate;

  @JsonKey(name: 'Description')
  final String? description;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final DateTime? updateDate;

  IncidentTypeApiModel({
    required this.id,
    required this.active,
    this.createBy,
    this.createDate,
    this.description,
    required this.name,
    this.updateBy,
    this.updateDate,
  });

  factory IncidentTypeApiModel.fromJson(Map<String, dynamic> json) =>
      _$IncidentTypeApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentTypeApiModelToJson(this);
}

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

