// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_list_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteListRequest _$RouteListRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RouteListRequest',
      json,
      ($checkedConvert) {
        final val = RouteListRequest(
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

Map<String, dynamic> _$RouteListRequestToJson(RouteListRequest instance) =>
    <String, dynamic>{
      'Filter': instance.filter.map((e) => e.toJson()).toList(),
      'Sort': instance.sort.toJson(),
      'Start': instance.start,
      'Length': instance.length,
    };

RouteListResponse _$RouteListResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RouteListResponse',
      json,
      ($checkedConvert) {
        final val = RouteListResponse(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) => RouteModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'count': 'Count',
        'filtered': 'Filtered',
        'list': 'List'
      },
    );

Map<String, dynamic> _$RouteListResponseToJson(RouteListResponse instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
    };

RouteModel _$RouteModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'RouteModel',
      json,
      ($checkedConvert) {
        final val = RouteModel(
          id: $checkedConvert('Id', (v) => v as String),
          name: $checkedConvert('Name', (v) => v as String),
          location: $checkedConvert('Location', (v) => (v as num?)?.toInt()),
          totalArea: $checkedConvert('TotalArea', (v) => (v as num?)?.toInt()),
          site: $checkedConvert(
              'Site',
              (v) => v == null
                  ? null
                  : SiteModel.fromJson(v as Map<String, dynamic>)),
          createdDate: $checkedConvert('CreateDate',
              (v) => v == null ? null : DateTime.parse(v as String)),
          createdBy: $checkedConvert('CreateBy', (v) => v as String?),
          modifiedDate: $checkedConvert('UpdateDate',
              (v) => v == null ? null : DateTime.parse(v as String)),
          modifiedBy: $checkedConvert('UpdateBy', (v) => v as String?),
          isActive: $checkedConvert('Active', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'name': 'Name',
        'location': 'Location',
        'totalArea': 'TotalArea',
        'site': 'Site',
        'createdDate': 'CreateDate',
        'createdBy': 'CreateBy',
        'modifiedDate': 'UpdateDate',
        'modifiedBy': 'UpdateBy',
        'isActive': 'Active'
      },
    );

Map<String, dynamic> _$RouteModelToJson(RouteModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Location': instance.location,
      'TotalArea': instance.totalArea,
      'Site': instance.site?.toJson(),
      'CreateDate': instance.createdDate?.toIso8601String(),
      'CreateBy': instance.createdBy,
      'UpdateDate': instance.modifiedDate?.toIso8601String(),
      'UpdateBy': instance.modifiedBy,
      'Active': instance.isActive,
    };

SiteModel _$SiteModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'SiteModel',
      json,
      ($checkedConvert) {
        final val = SiteModel(
          id: $checkedConvert('Id', (v) => (v as num).toInt()),
          name: $checkedConvert('Name', (v) => v as String),
          description: $checkedConvert('Description', (v) => v as String?),
          active: $checkedConvert('Active', (v) => v as bool?),
          createBy: $checkedConvert('CreateBy', (v) => v as String?),
          createDate: $checkedConvert('CreateDate',
              (v) => v == null ? null : DateTime.parse(v as String)),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'name': 'Name',
        'description': 'Description',
        'active': 'Active',
        'createBy': 'CreateBy',
        'createDate': 'CreateDate',
        'updateBy': 'UpdateBy',
        'updateDate': 'UpdateDate'
      },
    );

Map<String, dynamic> _$SiteModelToJson(SiteModel instance) => <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Description': instance.description,
      'Active': instance.active,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate?.toIso8601String(),
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate?.toIso8601String(),
    };
