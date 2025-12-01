// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_detail_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteDetailListResponse _$RouteDetailListResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'RouteDetailListResponse',
      json,
      ($checkedConvert) {
        final val = RouteDetailListResponse(
          count: $checkedConvert('Count', (v) => (v as num?)?.toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num?)?.toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>?)
                  ?.map((e) =>
                      RouteDetailModel.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$RouteDetailListResponseToJson(
        RouteDetailListResponse instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list?.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

RouteDetailModel _$RouteDetailModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RouteDetailModel',
      json,
      ($checkedConvert) {
        final val = RouteDetailModel(
          id: $checkedConvert('Id', (v) => v as String),
          idRoute: $checkedConvert('IdRoute', (v) => v as String),
          route: $checkedConvert(
              'Route',
              (v) => v == null
                  ? null
                  : RouteModel.fromJson(v as Map<String, dynamic>)),
          latitude: $checkedConvert('Latitude', (v) => (v as num?)?.toDouble()),
          longitude:
              $checkedConvert('Longitude', (v) => (v as num?)?.toDouble()),
          name: $checkedConvert('Name', (v) => v as String?),
          radius: $checkedConvert('Radius', (v) => (v as num?)?.toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'idRoute': 'IdRoute',
        'route': 'Route',
        'latitude': 'Latitude',
        'longitude': 'Longitude',
        'name': 'Name',
        'radius': 'Radius'
      },
    );

Map<String, dynamic> _$RouteDetailModelToJson(RouteDetailModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'IdRoute': instance.idRoute,
      'Route': instance.route?.toJson(),
      'Latitude': instance.latitude,
      'Longitude': instance.longitude,
      'Name': instance.name,
      'Radius': instance.radius,
    };

RouteModel _$RouteModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'RouteModel',
      json,
      ($checkedConvert) {
        final val = RouteModel(
          id: $checkedConvert('Id', (v) => v as String),
          active: $checkedConvert('Active', (v) => v as bool),
          createBy: $checkedConvert('CreateBy', (v) => v as String?),
          createDate: $checkedConvert('CreateDate',
              (v) => v == null ? null : DateTime.parse(v as String)),
          idSite: $checkedConvert('IdSite', (v) => (v as num).toInt()),
          site: $checkedConvert(
              'Site',
              (v) => v == null
                  ? null
                  : SiteModel.fromJson(v as Map<String, dynamic>)),
          name: $checkedConvert('Name', (v) => v as String),
          remarks: $checkedConvert('Remarks', (v) => v as String?),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate',
              (v) => v == null ? null : DateTime.parse(v as String)),
          totalArea: $checkedConvert('TotalArea', (v) => (v as num).toInt()),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'active': 'Active',
        'createBy': 'CreateBy',
        'createDate': 'CreateDate',
        'idSite': 'IdSite',
        'site': 'Site',
        'name': 'Name',
        'remarks': 'Remarks',
        'updateBy': 'UpdateBy',
        'updateDate': 'UpdateDate',
        'totalArea': 'TotalArea'
      },
    );

Map<String, dynamic> _$RouteModelToJson(RouteModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Active': instance.active,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate?.toIso8601String(),
      'IdSite': instance.idSite,
      'Site': instance.site?.toJson(),
      'Name': instance.name,
      'Remarks': instance.remarks,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate?.toIso8601String(),
      'TotalArea': instance.totalArea,
    };

SiteModel _$SiteModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'SiteModel',
      json,
      ($checkedConvert) {
        final val = SiteModel(
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

Map<String, dynamic> _$SiteModelToJson(SiteModel instance) => <String, dynamic>{
      'Id': instance.id,
      'Active': instance.active,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate?.toIso8601String(),
      'Description': instance.description,
      'Name': instance.name,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate?.toIso8601String(),
    };

RouteDetailListRequest _$RouteDetailListRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'RouteDetailListRequest',
      json,
      ($checkedConvert) {
        final val = RouteDetailListRequest(
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

Map<String, dynamic> _$RouteDetailListRequestToJson(
        RouteDetailListRequest instance) =>
    <String, dynamic>{
      'Filter': instance.filter.map((e) => e.toJson()).toList(),
      'Sort': instance.sort.toJson(),
      'Start': instance.start,
      'Length': instance.length,
    };

FilterModel _$FilterModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'FilterModel',
      json,
      ($checkedConvert) {
        final val = FilterModel(
          field: $checkedConvert('Field', (v) => v as String),
          search: $checkedConvert('Search', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'field': 'Field', 'search': 'Search'},
    );

Map<String, dynamic> _$FilterModelToJson(FilterModel instance) =>
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
