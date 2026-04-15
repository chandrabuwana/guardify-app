// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteResponseModel _$RouteResponseModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RouteResponseModel',
      json,
      ($checkedConvert) {
        final val = RouteResponseModel(
          data: $checkedConvert(
              'Data',
              (v) => v == null
                  ? null
                  : RouteDataModel.fromJson(v as Map<String, dynamic>)),
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String?),
          description: $checkedConvert('Description', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'data': 'Data',
        'code': 'Code',
        'succeeded': 'Succeeded',
        'message': 'Message',
        'description': 'Description'
      },
    );

Map<String, dynamic> _$RouteResponseModelToJson(RouteResponseModel instance) =>
    <String, dynamic>{
      'Data': instance.data?.toJson(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

RouteDataModel _$RouteDataModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RouteDataModel',
      json,
      ($checkedConvert) {
        final val = RouteDataModel(
          id: $checkedConvert('Id', (v) => v as String),
          name: $checkedConvert('Name', (v) => v as String),
          remarks: $checkedConvert('Remarks', (v) => v as String?),
          active: $checkedConvert('Active', (v) => v as bool?),
          idSite: $checkedConvert('IdSite', (v) => (v as num?)?.toInt()),
          site: $checkedConvert(
              'Site',
              (v) => v == null
                  ? null
                  : RouteSiteModel.fromJson(v as Map<String, dynamic>)),
          totalArea: $checkedConvert('TotalArea', (v) => (v as num?)?.toInt()),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'name': 'Name',
        'remarks': 'Remarks',
        'active': 'Active',
        'idSite': 'IdSite',
        'site': 'Site',
        'totalArea': 'TotalArea'
      },
    );

Map<String, dynamic> _$RouteDataModelToJson(RouteDataModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Remarks': instance.remarks,
      'Active': instance.active,
      'IdSite': instance.idSite,
      'Site': instance.site?.toJson(),
      'TotalArea': instance.totalArea,
    };

RouteSiteModel _$RouteSiteModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RouteSiteModel',
      json,
      ($checkedConvert) {
        final val = RouteSiteModel(
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

Map<String, dynamic> _$RouteSiteModelToJson(RouteSiteModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Active': instance.active,
      'Description': instance.description,
    };
