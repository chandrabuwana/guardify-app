import 'package:json_annotation/json_annotation.dart';
import 'panic_button_item_model.dart';

part 'panic_button_detail_response.g.dart';

@JsonSerializable()
class PanicButtonDetailResponse {
  @JsonKey(name: 'Data')
  final PanicButtonItemModel? data;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String description;

  PanicButtonDetailResponse({
    this.data,
    required this.code,
    required this.succeeded,
    required this.message,
    required this.description,
  });

  factory PanicButtonDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PanicButtonDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PanicButtonDetailResponseToJson(this);
}

