import 'package:json_annotation/json_annotation.dart';
import 'panic_button_item_model.dart';

part 'panic_button_list_response.g.dart';

@JsonSerializable()
class PanicButtonListResponse {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<PanicButtonItemModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String description;

  PanicButtonListResponse({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    required this.description,
  });

  factory PanicButtonListResponse.fromJson(Map<String, dynamic> json) =>
      _$PanicButtonListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PanicButtonListResponseToJson(this);
}

