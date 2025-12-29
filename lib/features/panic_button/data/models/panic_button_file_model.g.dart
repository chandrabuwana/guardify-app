// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panic_button_file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanicButtonFileModel _$PanicButtonFileModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PanicButtonFileModel',
      json,
      ($checkedConvert) {
        final val = PanicButtonFileModel(
          filename: $checkedConvert('Filename', (v) => v as String),
          url: $checkedConvert('Url', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'filename': 'Filename', 'url': 'Url'},
    );

Map<String, dynamic> _$PanicButtonFileModelToJson(
        PanicButtonFileModel instance) =>
    <String, dynamic>{
      'Filename': instance.filename,
      'Url': instance.url,
    };
