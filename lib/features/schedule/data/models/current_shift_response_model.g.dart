// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_shift_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentShiftResponseModel _$CurrentShiftResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CurrentShiftResponseModel',
      json,
      ($checkedConvert) {
        final val = CurrentShiftResponseModel(
          data: $checkedConvert(
              'Data',
              (v) => v == null
                  ? null
                  : CurrentShiftDataModel.fromJson(v as Map<String, dynamic>)),
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

Map<String, dynamic> _$CurrentShiftResponseModelToJson(
        CurrentShiftResponseModel instance) =>
    <String, dynamic>{
      'Data': instance.data?.toJson(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

CurrentShiftDataModel _$CurrentShiftDataModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CurrentShiftDataModel',
      json,
      ($checkedConvert) {
        final val = CurrentShiftDataModel(
          id: $checkedConvert('Id', (v) => v as String),
          name: $checkedConvert('Name', (v) => v as String),
          startTime: $checkedConvert('StartTime', (v) => v as String),
          checkin: $checkedConvert('Checkin', (v) => v as bool),
          checkout: $checkedConvert('Checkout', (v) => v as bool),
          checkinTime: $checkedConvert('CheckinTime', (v) => v as String?),
          checkoutTime: $checkedConvert('CheckoutTime', (v) => v as String?),
          listPersonel: $checkedConvert(
              'ListPersonel',
              (v) => (v as List<dynamic>)
                  .map(
                      (e) => PersonnelModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          idShiftDetail: $checkedConvert('IdShiftDetail', (v) => v as String?),
          shiftDate: $checkedConvert('ShiftDate', (v) => v as String?),
          location: $checkedConvert('Location', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'name': 'Name',
        'startTime': 'StartTime',
        'checkin': 'Checkin',
        'checkout': 'Checkout',
        'checkinTime': 'CheckinTime',
        'checkoutTime': 'CheckoutTime',
        'listPersonel': 'ListPersonel',
        'idShiftDetail': 'IdShiftDetail',
        'shiftDate': 'ShiftDate',
        'location': 'Location'
      },
    );

Map<String, dynamic> _$CurrentShiftDataModelToJson(
        CurrentShiftDataModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'StartTime': instance.startTime,
      'Checkin': instance.checkin,
      'Checkout': instance.checkout,
      'CheckinTime': instance.checkinTime,
      'CheckoutTime': instance.checkoutTime,
      'ListPersonel': instance.listPersonel.map((e) => e.toJson()).toList(),
      'IdShiftDetail': instance.idShiftDetail,
      'ShiftDate': instance.shiftDate,
      'Location': instance.location,
    };
