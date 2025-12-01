// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_list_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AreaListResponse _$AreaListResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AreaListResponse',
      json,
      ($checkedConvert) {
        final val = AreaListResponse(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) => AreaModel.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$AreaListResponseToJson(AreaListResponse instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

AreaModel _$AreaModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'AreaModel',
      json,
      ($checkedConvert) {
        final val = AreaModel(
          id: $checkedConvert('Id', (v) => v as String),
          active: $checkedConvert('Active', (v) => v as bool),
          createBy: $checkedConvert('CreateBy', (v) => v as String?),
          createDate: $checkedConvert('CreateDate',
              (v) => v == null ? null : DateTime.parse(v as String)),
          idSite: $checkedConvert('IdSite', (v) => (v as num).toInt()),
          latitude: $checkedConvert('Latitude', (v) => (v as num?)?.toDouble()),
          longitude:
              $checkedConvert('Longitude', (v) => (v as num?)?.toDouble()),
          name: $checkedConvert('Name', (v) => v as String?),
          radius: $checkedConvert('Radius', (v) => (v as num?)?.toDouble()),
          typeArea: $checkedConvert('TypeArea', (v) => v as String?),
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

Map<String, dynamic> _$AreaModelToJson(AreaModel instance) => <String, dynamic>{
      'Id': instance.id,
      'Active': instance.active,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate?.toIso8601String(),
      'IdSite': instance.idSite,
      'Latitude': instance.latitude,
      'Longitude': instance.longitude,
      'Name': instance.name,
      'Radius': instance.radius,
      'TypeArea': instance.typeArea,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate?.toIso8601String(),
    };

AreaListRequest _$AreaListRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AreaListRequest',
      json,
      ($checkedConvert) {
        final val = AreaListRequest(
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

Map<String, dynamic> _$AreaListRequestToJson(AreaListRequest instance) =>
    <String, dynamic>{
      'Filter': instance.filter.map((e) => e.toJson()).toList(),
      'Sort': instance.sort.toJson(),
      'Start': instance.start,
      'Length': instance.length,
    };
