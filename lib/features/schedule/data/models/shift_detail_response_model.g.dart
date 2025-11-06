// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_detail_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftDetailResponseModel _$ShiftDetailResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ShiftDetailResponseModel',
      json,
      ($checkedConvert) {
        final val = ShiftDetailResponseModel(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      ShiftDetailItemModel.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$ShiftDetailResponseModelToJson(
        ShiftDetailResponseModel instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

ShiftDetailItemModel _$ShiftDetailItemModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ShiftDetailItemModel',
      json,
      ($checkedConvert) {
        final val = ShiftDetailItemModel(
          id: $checkedConvert('Id', (v) => v as String),
          idShift: $checkedConvert('IdShift', (v) => v as String),
          shift: $checkedConvert(
              'Shift', (v) => ShiftModel.fromJson(v as Map<String, dynamic>)),
          userId: $checkedConvert('UserId', (v) => v as String?),
          user: $checkedConvert(
              'User',
              (v) => v == null
                  ? null
                  : UserModel.fromJson(v as Map<String, dynamic>)),
          idRoute: $checkedConvert('IdRoute', (v) => v as String?),
          route: $checkedConvert(
              'Route',
              (v) => v == null
                  ? null
                  : RouteModel.fromJson(v as Map<String, dynamic>)),
          location: $checkedConvert('Location', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'idShift': 'IdShift',
        'shift': 'Shift',
        'userId': 'UserId',
        'user': 'User',
        'idRoute': 'IdRoute',
        'route': 'Route',
        'location': 'Location'
      },
    );

Map<String, dynamic> _$ShiftDetailItemModelToJson(
        ShiftDetailItemModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'IdShift': instance.idShift,
      'Shift': instance.shift.toJson(),
      'UserId': instance.userId,
      'User': instance.user?.toJson(),
      'IdRoute': instance.idRoute,
      'Route': instance.route?.toJson(),
      'Location': instance.location,
    };

ShiftModel _$ShiftModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ShiftModel',
      json,
      ($checkedConvert) {
        final val = ShiftModel(
          id: $checkedConvert('Id', (v) => v as String),
          shiftDate: $checkedConvert('ShiftDate', (v) => v as String),
          idShiftCategory:
              $checkedConvert('IdShiftCategory', (v) => (v as num).toInt()),
          shiftCategory: $checkedConvert(
              'ShiftCategory',
              (v) => v == null
                  ? null
                  : ShiftCategoryModel.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'shiftDate': 'ShiftDate',
        'idShiftCategory': 'IdShiftCategory',
        'shiftCategory': 'ShiftCategory'
      },
    );

Map<String, dynamic> _$ShiftModelToJson(ShiftModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'ShiftDate': instance.shiftDate,
      'IdShiftCategory': instance.idShiftCategory,
      'ShiftCategory': instance.shiftCategory?.toJson(),
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'UserModel',
      json,
      ($checkedConvert) {
        final val = UserModel(
          id: $checkedConvert('Id', (v) => v as String),
          username: $checkedConvert('Username', (v) => v as String?),
          fullname: $checkedConvert('Fullname', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'username': 'Username',
        'fullname': 'Fullname'
      },
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'Id': instance.id,
      'Username': instance.username,
      'Fullname': instance.fullname,
    };

RouteModel _$RouteModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'RouteModel',
      json,
      ($checkedConvert) {
        final val = RouteModel(
          id: $checkedConvert('Id', (v) => v as String),
          name: $checkedConvert('Name', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'id': 'Id', 'name': 'Name'},
    );

Map<String, dynamic> _$RouteModelToJson(RouteModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
    };
