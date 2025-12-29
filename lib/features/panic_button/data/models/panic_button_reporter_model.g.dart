// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panic_button_reporter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanicButtonReporterModel _$PanicButtonReporterModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PanicButtonReporterModel',
      json,
      ($checkedConvert) {
        final val = PanicButtonReporterModel(
          id: $checkedConvert('Id', (v) => v as String),
          username: $checkedConvert('Username', (v) => v as String?),
          fullname: $checkedConvert('Fullname', (v) => v as String?),
          noNrp: $checkedConvert('NoNrp', (v) => v as String?),
          email: $checkedConvert('Email', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'username': 'Username',
        'fullname': 'Fullname',
        'noNrp': 'NoNrp',
        'email': 'Email'
      },
    );

Map<String, dynamic> _$PanicButtonReporterModelToJson(
        PanicButtonReporterModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Username': instance.username,
      'Fullname': instance.fullname,
      'NoNrp': instance.noNrp,
      'Email': instance.email,
    };
