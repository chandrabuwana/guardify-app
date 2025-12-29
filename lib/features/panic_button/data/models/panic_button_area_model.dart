import 'package:json_annotation/json_annotation.dart';

part 'panic_button_area_model.g.dart';

@JsonSerializable()
class PanicButtonAreaModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Active')
  final bool active;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final String? createDate;

  @JsonKey(name: 'IdSite')
  final int idSite;

  @JsonKey(name: 'Latitude')
  final double? latitude;

  @JsonKey(name: 'Longitude')
  final double? longitude;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Radius')
  final double radius;

  @JsonKey(name: 'TypeArea')
  final String typeArea;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final String? updateDate;

  PanicButtonAreaModel({
    required this.id,
    required this.active,
    this.createBy,
    this.createDate,
    required this.idSite,
    this.latitude,
    this.longitude,
    required this.name,
    required this.radius,
    required this.typeArea,
    this.updateBy,
    this.updateDate,
  });

  factory PanicButtonAreaModel.fromJson(Map<String, dynamic> json) =>
      _$PanicButtonAreaModelFromJson(json);

  Map<String, dynamic> toJson() => _$PanicButtonAreaModelToJson(this);
}

