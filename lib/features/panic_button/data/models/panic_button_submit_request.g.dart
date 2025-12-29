// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panic_button_submit_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanicButtonSubmitRequest _$PanicButtonSubmitRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PanicButtonSubmitRequest',
      json,
      ($checkedConvert) {
        final val = PanicButtonSubmitRequest(
          id: $checkedConvert('Id', (v) => v as String),
          status: $checkedConvert('Status', (v) => v as String),
          notes: $checkedConvert('Feedback', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'id': 'Id', 'status': 'Status', 'notes': 'Feedback'},
    );

Map<String, dynamic> _$PanicButtonSubmitRequestToJson(
        PanicButtonSubmitRequest instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Status': instance.status,
      'Feedback': instance.notes,
    };
