// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_type_list_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncidentTypeListResponse _$IncidentTypeListResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'IncidentTypeListResponse',
      json,
      ($checkedConvert) {
        final val = IncidentTypeListResponse(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      IncidentTypeApiModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String),
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

Map<String, dynamic> _$IncidentTypeListResponseToJson(
        IncidentTypeListResponse instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

IncidentTypeApiModel _$IncidentTypeApiModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'IncidentTypeApiModel',
      json,
      ($checkedConvert) {
        final val = IncidentTypeApiModel(
          id: $checkedConvert('Id', (v) => (v as num).toInt()),
          active: $checkedConvert('Active', (v) => v as bool),
          createBy: $checkedConvert('CreateBy', (v) => v as String?),
          createDate: $checkedConvert('CreateDate',
              (v) => v == null ? null : DateTime.parse(v as String)),
          description: $checkedConvert('Description', (v) => v as String?),
          name: $checkedConvert('Name', (v) => v as String),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate',
              (v) => v == null ? null : DateTime.parse(v as String)),
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

Map<String, dynamic> _$IncidentTypeApiModelToJson(
        IncidentTypeApiModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Active': instance.active,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate?.toIso8601String(),
      'Description': instance.description,
      'Name': instance.name,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate?.toIso8601String(),
    };

IncidentTypeListRequest _$IncidentTypeListRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'IncidentTypeListRequest',
      json,
      ($checkedConvert) {
        final val = IncidentTypeListRequest(
          filter: $checkedConvert(
              'Filter',
              (v) => (v as List<dynamic>)
                  .map((e) => FilterModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          sort: $checkedConvert(
              'Sort', (v) => SortModel.fromJson(v as Map<String, dynamic>)),
          start: $checkedConvert('Start', (v) => (v as num).toInt()),
          length: $checkedConvert('Length', (v) => (v as num).toInt()),
        );
        return val;
      },
      fieldKeyMap: const {
        'filter': 'Filter',
        'sort': 'Sort',
        'start': 'Start',
        'length': 'Length'
      },
    );

Map<String, dynamic> _$IncidentTypeListRequestToJson(
        IncidentTypeListRequest instance) =>
    <String, dynamic>{
      'Filter': instance.filter.map((e) => e.toJson()).toList(),
      'Sort': instance.sort.toJson(),
      'Start': instance.start,
      'Length': instance.length,
    };
