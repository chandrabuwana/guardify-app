// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveRequestFilterModel _$LeaveRequestFilterModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'LeaveRequestFilterModel',
      json,
      ($checkedConvert) {
        final val = LeaveRequestFilterModel(
          filter: $checkedConvert(
              'Filter',
              (v) => (v as List<dynamic>?)
                  ?.map((e) =>
                      FilterFieldModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          sort: $checkedConvert(
              'Sort',
              (v) => v == null
                  ? null
                  : SortModel.fromJson(v as Map<String, dynamic>)),
          start: $checkedConvert('Start', (v) => (v as num?)?.toInt() ?? 0),
          length: $checkedConvert('Length', (v) => (v as num?)?.toInt() ?? 0),
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

Map<String, dynamic> _$LeaveRequestFilterModelToJson(
        LeaveRequestFilterModel instance) =>
    <String, dynamic>{
      'Filter': instance.filter?.map((e) => e.toJson()).toList(),
      'Sort': instance.sort?.toJson(),
      'Start': instance.start,
      'Length': instance.length,
    };

FilterFieldModel _$FilterFieldModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'FilterFieldModel',
      json,
      ($checkedConvert) {
        final val = FilterFieldModel(
          field: $checkedConvert('Field', (v) => v as String),
          search: $checkedConvert('Search', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'field': 'Field', 'search': 'Search'},
    );

Map<String, dynamic> _$FilterFieldModelToJson(FilterFieldModel instance) =>
    <String, dynamic>{
      'Field': instance.field,
      'Search': instance.search,
    };

SortModel _$SortModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'SortModel',
      json,
      ($checkedConvert) {
        final val = SortModel(
          field: $checkedConvert('Field', (v) => v as String),
          type: $checkedConvert('Type', (v) => (v as num).toInt()),
        );
        return val;
      },
      fieldKeyMap: const {'field': 'Field', 'type': 'Type'},
    );

Map<String, dynamic> _$SortModelToJson(SortModel instance) => <String, dynamic>{
      'Field': instance.field,
      'Type': instance.type,
    };
