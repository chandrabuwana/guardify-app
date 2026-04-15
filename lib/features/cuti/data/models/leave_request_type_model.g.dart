// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveRequestTypeModel _$LeaveRequestTypeModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'LeaveRequestTypeModel',
      json,
      ($checkedConvert) {
        final val = LeaveRequestTypeModel(
          id: $checkedConvert('Id', (v) => (v as num).toInt()),
          active: $checkedConvert('Active', (v) => v as bool?),
          createBy: $checkedConvert('CreateBy', (v) => v as String?),
          createDate: $checkedConvert('CreateDate', (v) => v as String?),
          description: $checkedConvert('Description', (v) => v as String?),
          name: $checkedConvert('Name', (v) => v as String?),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate', (v) => v as String?),
          quota: $checkedConvert('Quota', (v) => (v as num?)?.toInt()),
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
        'updateDate': 'UpdateDate',
        'quota': 'Quota'
      },
    );

Map<String, dynamic> _$LeaveRequestTypeModelToJson(
        LeaveRequestTypeModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Active': instance.active,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate,
      'Description': instance.description,
      'Name': instance.name,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate,
      'Quota': instance.quota,
    };

LeaveRequestTypeListResponseModel _$LeaveRequestTypeListResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'LeaveRequestTypeListResponseModel',
      json,
      ($checkedConvert) {
        final val = LeaveRequestTypeListResponseModel(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      LeaveRequestTypeModel.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$LeaveRequestTypeListResponseModelToJson(
        LeaveRequestTypeListResponseModel instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

LeaveRequestTypeListRequestModel _$LeaveRequestTypeListRequestModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'LeaveRequestTypeListRequestModel',
      json,
      ($checkedConvert) {
        final val = LeaveRequestTypeListRequestModel(
          filter: $checkedConvert(
              'Filter',
              (v) => (v as List<dynamic>)
                  .map((e) => Map<String, String>.from(e as Map))
                  .toList()),
          sort: $checkedConvert('Sort', (v) => v as Map<String, dynamic>),
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

Map<String, dynamic> _$LeaveRequestTypeListRequestModelToJson(
        LeaveRequestTypeListRequestModel instance) =>
    <String, dynamic>{
      'Filter': instance.filter,
      'Sort': instance.sort,
      'Start': instance.start,
      'Length': instance.length,
    };
