import 'package:json_annotation/json_annotation.dart';

part 'panic_button_submit_request.g.dart';

@JsonSerializable()
class PanicButtonSubmitRequest {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Status')
  final String status;

  @JsonKey(name: 'Feedback')
  final String? notes;

  PanicButtonSubmitRequest({
    required this.id,
    required this.status,
    this.notes,
  });

  factory PanicButtonSubmitRequest.fromJson(Map<String, dynamic> json) =>
      _$PanicButtonSubmitRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PanicButtonSubmitRequestToJson(this);
}

