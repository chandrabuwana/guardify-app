import 'package:json_annotation/json_annotation.dart';
import 'route_detail_api_response.dart'; // Import FilterModel and SortModel

part 'area_list_api_response.g.dart';

/// Response model untuk Areas List API
@JsonSerializable()
class AreaListResponse {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<AreaModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  AreaListResponse({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory AreaListResponse.fromJson(Map<String, dynamic> json) =>
      _$AreaListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AreaListResponseToJson(this);
}

/// Model untuk Area dari API
@JsonSerializable()
class AreaModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Active')
  final bool active;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final DateTime? createDate;

  @JsonKey(name: 'IdSite')
  final int idSite;

  @JsonKey(name: 'Latitude')
  final double? latitude;

  @JsonKey(name: 'Longitude')
  final double? longitude;

  @JsonKey(name: 'Name')
  final String? name;

  @JsonKey(name: 'Radius')
  final double? radius;

  @JsonKey(name: 'TypeArea')
  final String? typeArea;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final DateTime? updateDate;

  AreaModel({
    required this.id,
    required this.active,
    this.createBy,
    this.createDate,
    required this.idSite,
    this.latitude,
    this.longitude,
    this.name,
    this.radius,
    this.typeArea,
    this.updateBy,
    this.updateDate,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) =>
      _$AreaModelFromJson(json);

  Map<String, dynamic> toJson() => _$AreaModelToJson(this);
}

/// Request model untuk Areas List API
@JsonSerializable()
class AreaListRequest {
  @JsonKey(name: 'Filter')
  final List<FilterModel> filter;

  @JsonKey(name: 'Sort')
  final SortModel sort;

  @JsonKey(name: 'Start')
  final int start;

  @JsonKey(name: 'Length')
  final int length;

  AreaListRequest({
    required this.filter,
    required this.sort,
    required this.start,
    required this.length,
  });

  factory AreaListRequest.fromJson(Map<String, dynamic> json) =>
      _$AreaListRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AreaListRequestToJson(this);
}

