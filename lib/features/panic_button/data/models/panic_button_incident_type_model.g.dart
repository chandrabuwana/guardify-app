// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panic_button_incident_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanicButtonIncidentTypeModel _$PanicButtonIncidentTypeModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PanicButtonIncidentTypeModel',
      json,
      ($checkedConvert) {
        final val = PanicButtonIncidentTypeModel(
          id: $checkedConvert('Id', (v) => (v as num).toInt()),
          active: $checkedConvert('Active', (v) => v as bool),
          createBy: $checkedConvert('CreateBy', (v) => v as String?),
          createDate: $checkedConvert('CreateDate', (v) => v as String?),
          description: $checkedConvert('Description', (v) => v as String),
          name: $checkedConvert('Name', (v) => v as String),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'active': 'Active',
        'createBy': 'CreateBy',
        'createDate': 'CreateDate',
        'description': 'Description',
        'name': 'Name',
        'updateBy': 'UpdateBy',
        'updateDate': 'UpdateDate'
      },
    );

Map<String, dynamic> _$PanicButtonIncidentTypeModelToJson(
        PanicButtonIncidentTypeModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Active': instance.active,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate,
      'Description': instance.description,
      'Name': instance.name,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate,
    };
