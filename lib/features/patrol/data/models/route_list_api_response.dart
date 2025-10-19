import 'package:json_annotation/json_annotation.dart';
import 'route_detail_api_response.dart';

part 'route_list_api_response.g.dart';

@JsonSerializable()
class RouteListRequest {
  @JsonKey(name: 'Filter')
  final List<FilterModel> filter;

  @JsonKey(name: 'Sort')
  final SortModel sort;

  @JsonKey(name: 'Start')
  final int start;

  @JsonKey(name: 'Length')
  final int length;

  RouteListRequest({
    required this.filter,
    required this.sort,
    required this.start,
    required this.length,
  });

  factory RouteListRequest.fromJson(Map<String, dynamic> json) =>
      _$RouteListRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RouteListRequestToJson(this);
}

@JsonSerializable()
class RouteListResponse {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<RouteModel> list;

  RouteListResponse({
    required this.count,
    required this.filtered,
    required this.list,
  });

  factory RouteListResponse.fromJson(Map<String, dynamic> json) =>
      _$RouteListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RouteListResponseToJson(this);
}

@JsonSerializable()
class RouteModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Location')
  final int? location;

  @JsonKey(name: 'TotalArea')
  final int? totalArea;

  @JsonKey(name: 'Site')
  final SiteModel? site;

  @JsonKey(name: 'CreateDate')
  final DateTime? createdDate;

  @JsonKey(name: 'CreateBy')
  final String? createdBy;

  @JsonKey(name: 'UpdateDate')
  final DateTime? modifiedDate;

  @JsonKey(name: 'UpdateBy')
  final String? modifiedBy;

  @JsonKey(name: 'Active')
  final bool? isActive;

  RouteModel({
    required this.id,
    required this.name,
    this.location,
    this.totalArea,
    this.site,
    this.createdDate,
    this.createdBy,
    this.modifiedDate,
    this.modifiedBy,
    this.isActive,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteModelToJson(this);
}

@JsonSerializable()
class SiteModel {
  @JsonKey(name: 'Id')
  final int id;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Description')
  final String? description;

  @JsonKey(name: 'Active')
  final bool? active;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final DateTime? createDate;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final DateTime? updateDate;

  SiteModel({
    required this.id,
    required this.name,
    this.description,
    this.active,
    this.createBy,
    this.createDate,
    this.updateBy,
    this.updateDate,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) =>
      _$SiteModelFromJson(json);

  Map<String, dynamic> toJson() => _$SiteModelToJson(this);
}
