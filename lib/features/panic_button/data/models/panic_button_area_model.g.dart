// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panic_button_area_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanicButtonAreaModel _$PanicButtonAreaModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PanicButtonAreaModel',
      json,
      ($checkedConvert) {
        final val = PanicButtonAreaModel(
          id: $checkedConvert('Id', (v) => v as String),
          active: $checkedConvert('Active', (v) => v as bool),
          createBy: $checkedConvert('CreateBy', (v) => v as String?),
          createDate: $checkedConvert('CreateDate', (v) => v as String?),
          idSite: $checkedConvert('IdSite', (v) => (v as num).toInt()),
          latitude: $checkedConvert('Latitude', (v) => (v as num?)?.toDouble()),
          longitude:
              $checkedConvert('Longitude', (v) => (v as num?)?.toDouble()),
          name: $checkedConvert('Name', (v) => v as String),
          radius: $checkedConvert('Radius', (v) => (v as num).toDouble()),
          typeArea: $checkedConvert('TypeArea', (v) => v as String),
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
        'idSite': 'IdSite',
        'latitude': 'Latitude',
        'longitude': 'Longitude',
        'name': 'Name',
        'radius': 'Radius',
        'typeArea': 'TypeArea',
        'updateBy': 'UpdateBy',
        'updateDate': 'UpdateDate'
      },
    );

Map<String, dynamic> _$PanicButtonAreaModelToJson(
        PanicButtonAreaModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Active': instance.active,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate,
      'IdSite': instance.idSite,
      'Latitude': instance.latitude,
      'Longitude': instance.longitude,
      'Name': instance.name,
      'Radius': instance.radius,
      'TypeArea': instance.typeArea,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate,
    };
