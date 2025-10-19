import 'package:json_annotation/json_annotation.dart';

part 'route_detail_api_response.g.dart';

/// Response model untuk Route Detail List API
@JsonSerializable()
class RouteDetailListResponse {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<RouteDetailModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  RouteDetailListResponse({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory RouteDetailListResponse.fromJson(Map<String, dynamic> json) =>
      _$RouteDetailListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RouteDetailListResponseToJson(this);
}

/// Model untuk Route Detail dari API
@JsonSerializable()
class RouteDetailModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'IdRoute')
  final String idRoute;

  @JsonKey(name: 'Route')
  final RouteModel? route;

  @JsonKey(name: 'Latitude')
  final double latitude;

  @JsonKey(name: 'Longitude')
  final double longitude;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Radius')
  final double radius;

  RouteDetailModel({
    required this.id,
    required this.idRoute,
    this.route,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.radius,
  });

  factory RouteDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RouteDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteDetailModelToJson(this);
}

/// Model untuk Route dari API
@JsonSerializable()
class RouteModel {
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

  @JsonKey(name: 'Site')
  final SiteModel? site;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Remarks')
  final String? remarks;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final DateTime? updateDate;

  @JsonKey(name: 'TotalArea')
  final int totalArea;

  RouteModel({
    required this.id,
    required this.active,
    this.createBy,
    this.createDate,
    required this.idSite,
    this.site,
    required this.name,
    this.remarks,
    this.updateBy,
    this.updateDate,
    required this.totalArea,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteModelToJson(this);
}

/// Model untuk Site dari API
@JsonSerializable()
class SiteModel {
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

  SiteModel({
    required this.id,
    required this.active,
    this.createBy,
    this.createDate,
    this.description,
    required this.name,
    this.updateBy,
    this.updateDate,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) =>
      _$SiteModelFromJson(json);

  Map<String, dynamic> toJson() => _$SiteModelToJson(this);
}

/// Request model untuk Route Detail List API
@JsonSerializable()
class RouteDetailListRequest {
  @JsonKey(name: 'Filter')
  final List<FilterModel> filter;

  @JsonKey(name: 'Sort')
  final SortModel sort;

  @JsonKey(name: 'Start')
  final int start;

  @JsonKey(name: 'Length')
  final int length;

  RouteDetailListRequest({
    required this.filter,
    required this.sort,
    required this.start,
    required this.length,
  });

  factory RouteDetailListRequest.fromJson(Map<String, dynamic> json) =>
      _$RouteDetailListRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RouteDetailListRequestToJson(this);
}

@JsonSerializable()
class FilterModel {
  @JsonKey(name: 'Field')
  final String field;

  @JsonKey(name: 'Search')
  final String search;

  FilterModel({
    required this.field,
    required this.search,
  });

  factory FilterModel.fromJson(Map<String, dynamic> json) =>
      _$FilterModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterModelToJson(this);
}

@JsonSerializable()
class SortModel {
  @JsonKey(name: 'Field')
  final String field;

  @JsonKey(name: 'Type')
  final int type;

  SortModel({
    required this.field,
    required this.type,
  });

  factory SortModel.fromJson(Map<String, dynamic> json) =>
      _$SortModelFromJson(json);

  Map<String, dynamic> toJson() => _$SortModelToJson(this);
}
