// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_type_list_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
