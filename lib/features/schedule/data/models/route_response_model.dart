import 'package:json_annotation/json_annotation.dart';

part 'route_response_model.g.dart';

/// Response model for Route GET API
@JsonSerializable()
class RouteResponseModel {
  @JsonKey(name: 'Data')
  final RouteDataModel? data;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Description')
  final String? description;

  RouteResponseModel({
    this.data,
    required this.code,
    required this.succeeded,
    this.message,
    this.description,
  });

  factory RouteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RouteResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteResponseModelToJson(this);
}

/// Route data model
@JsonSerializable()
class RouteDataModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Remarks')
  final String? remarks;

  @JsonKey(name: 'Active')
  final bool? active;

  @JsonKey(name: 'IdSite')
  final int? idSite;

  @JsonKey(name: 'Site')
  final RouteSiteModel? site;

  @JsonKey(name: 'TotalArea')
  final int? totalArea;

  RouteDataModel({
    required this.id,
    required this.name,
    this.remarks,
    this.active,
    this.idSite,
    this.site,
    this.totalArea,
  });

  factory RouteDataModel.fromJson(Map<String, dynamic> json) =>
      _$RouteDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteDataModelToJson(this);
}

/// Site model for Route
@JsonSerializable()
class RouteSiteModel {
  @JsonKey(name: 'Id')
  final int id;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Active')
  final bool? active;

  @JsonKey(name: 'Description')
  final String? description;

  RouteSiteModel({
    required this.id,
    required this.name,
    this.active,
    this.description,
  });

  factory RouteSiteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteSiteModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteSiteModelToJson(this);
}
