import 'package:json_annotation/json_annotation.dart';

part 'panic_button_submit_response.g.dart';

@JsonSerializable()
class PanicButtonSubmitResponse {
  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String description;

  PanicButtonSubmitResponse({
    required this.code,
    required this.succeeded,
    required this.message,
    required this.description,
  });

  factory PanicButtonSubmitResponse.fromJson(Map<String, dynamic> json) =>
      _$PanicButtonSubmitResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PanicButtonSubmitResponseToJson(this);
}

