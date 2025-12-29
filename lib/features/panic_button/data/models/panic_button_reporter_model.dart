import 'package:json_annotation/json_annotation.dart';

part 'panic_button_reporter_model.g.dart';

@JsonSerializable()
class PanicButtonReporterModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Username')
  final String? username;

  @JsonKey(name: 'Fullname')
  final String? fullname;

  @JsonKey(name: 'NoNrp')
  final String? noNrp;

  @JsonKey(name: 'Email')
  final String? email;

  PanicButtonReporterModel({
    required this.id,
    this.username,
    this.fullname,
    this.noNrp,
    this.email,
  });

  factory PanicButtonReporterModel.fromJson(Map<String, dynamic> json) =>
      _$PanicButtonReporterModelFromJson(json);

  Map<String, dynamic> toJson() => _$PanicButtonReporterModelToJson(this);
}

