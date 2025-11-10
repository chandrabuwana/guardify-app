// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_category_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftCategoryResponseModel _$ShiftCategoryResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ShiftCategoryResponseModel',
      json,
      ($checkedConvert) {
        final val = ShiftCategoryResponseModel(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      ShiftCategoryModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String?),
          description: $checkedConvert('Description', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'count': 'Count',
        'filtered': 'Filtered',
        'list': 'List',
        'code': 'Code',
        'succeeded': 'Succeeded',
        'message': 'Message',
        'description': 'Description'
      },
    );

Map<String, dynamic> _$ShiftCategoryResponseModelToJson(
        ShiftCategoryResponseModel instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

ShiftCategoryModel _$ShiftCategoryModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ShiftCategoryModel',
      json,
      ($checkedConvert) {
        final val = ShiftCategoryModel(
          id: $checkedConvert('Id', (v) => (v as num).toInt()),
          name: $checkedConvert('Name', (v) => v as String),
          startTime: $checkedConvert('StartTime', (v) => v as String),
          endTime: $checkedConvert('EndTime', (v) => v as String),
          active: $checkedConvert('Active', (v) => v as bool?),
          idSite: $checkedConvert('IdSite', (v) => (v as num?)?.toInt()),
          site: $checkedConvert(
              'Site',
              (v) => v == null
                  ? null
                  : SiteModel.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'name': 'Name',
        'startTime': 'StartTime',
        'endTime': 'EndTime',
        'active': 'Active',
        'idSite': 'IdSite',
        'site': 'Site'
      },
    );

Map<String, dynamic> _$ShiftCategoryModelToJson(ShiftCategoryModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'StartTime': instance.startTime,
      'EndTime': instance.endTime,
      'Active': instance.active,
      'IdSite': instance.idSite,
      'Site': instance.site?.toJson(),
    };

SiteModel _$SiteModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'SiteModel',
      json,
      ($checkedConvert) {
        final val = SiteModel(
          id: $checkedConvert('Id', (v) => (v as num).toInt()),
          name: $checkedConvert('Name', (v) => v as String),
          active: $checkedConvert('Active', (v) => v as bool?),
          description: $checkedConvert('Description', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'name': 'Name',
        'active': 'Active',
        'description': 'Description'
      },
    );

Map<String, dynamic> _$SiteModelToJson(SiteModel instance) => <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Active': instance.active,
      'Description': instance.description,
    };
