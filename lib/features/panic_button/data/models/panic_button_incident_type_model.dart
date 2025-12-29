import 'package:json_annotation/json_annotation.dart';

part 'panic_button_incident_type_model.g.dart';

@JsonSerializable()
class PanicButtonIncidentTypeModel {
  @JsonKey(name: 'Id')
  final int id;

  @JsonKey(name: 'Active')
  final bool active;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final String? createDate;

  @JsonKey(name: 'Description')
  final String description;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final String? updateDate;

  PanicButtonIncidentTypeModel({
    required this.id,
    required this.active,
    this.createBy,
    this.createDate,
    required this.description,
    required this.name,
    this.updateBy,
    this.updateDate,
  });

  factory PanicButtonIncidentTypeModel.fromJson(Map<String, dynamic> json) =>
      _$PanicButtonIncidentTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$PanicButtonIncidentTypeModelToJson(this);
}

