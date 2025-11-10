import 'package:json_annotation/json_annotation.dart';

part 'shift_category_response_model.g.dart';

/// Response model for ShiftCategory API
@JsonSerializable()
class ShiftCategoryResponseModel {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<ShiftCategoryModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Description')
  final String? description;

  ShiftCategoryResponseModel({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    this.message,
    this.description,
  });

  factory ShiftCategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftCategoryResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftCategoryResponseModelToJson(this);
}

/// Model for individual ShiftCategory
@JsonSerializable()
class ShiftCategoryModel {
  @JsonKey(name: 'Id')
  final int id;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'StartTime')
  final String startTime;

  @JsonKey(name: 'EndTime')
  final String endTime;

  @JsonKey(name: 'Active')
  final bool? active;

  @JsonKey(name: 'IdSite')
  final int? idSite;

  @JsonKey(name: 'Site')
  final SiteModel? site;

  ShiftCategoryModel({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    this.active,
    this.idSite,
    this.site,
  });

  factory ShiftCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftCategoryModelToJson(this);

  /// Get formatted time range (e.g., "07:00 - 12:00 WIB")
  String getFormattedTime() {
    final start = startTime.substring(0, 5); // Get HH:mm
    final end = endTime.substring(0, 5);
    return '$start - $end WIB';
  }
}

/// Site model for ShiftCategory
@JsonSerializable()
class SiteModel {
  @JsonKey(name: 'Id')
  final int id;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Active')
  final bool? active;

  @JsonKey(name: 'Description')
  final String? description;

  SiteModel({
    required this.id,
    required this.name,
    this.active,
    this.description,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) =>
      _$SiteModelFromJson(json);

  Map<String, dynamic> toJson() => _$SiteModelToJson(this);
}
