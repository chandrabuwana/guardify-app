import 'package:json_annotation/json_annotation.dart';

part 'password_action_response_model.g.dart';

@JsonSerializable()
class PasswordActionResponseModel {
  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Description')
  final String? description;

  const PasswordActionResponseModel({
    required this.code,
    required this.succeeded,
    this.message,
    this.description,
  });

  factory PasswordActionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PasswordActionResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordActionResponseModelToJson(this);
}
