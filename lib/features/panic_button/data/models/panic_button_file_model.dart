import 'package:json_annotation/json_annotation.dart';

part 'panic_button_file_model.g.dart';

@JsonSerializable()
class PanicButtonFileModel {
  @JsonKey(name: 'Filename')
  final String filename;

  @JsonKey(name: 'Url')
  final String url;

  PanicButtonFileModel({
    required this.filename,
    required this.url,
  });

  factory PanicButtonFileModel.fromJson(Map<String, dynamic> json) =>
      _$PanicButtonFileModelFromJson(json);

  Map<String, dynamic> toJson() => _$PanicButtonFileModelToJson(this);
}

