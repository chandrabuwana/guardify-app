// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_leave_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLeaveRequestModel _$CreateLeaveRequestModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateLeaveRequestModel',
      json,
      ($checkedConvert) {
        final val = CreateLeaveRequestModel(
          approveDate: $checkedConvert('ApproveDate', (v) => v as String?),
          endDate: $checkedConvert('EndDate', (v) => v as String),
          idLeaveRequestType:
              $checkedConvert('IdLeaveRequestType', (v) => (v as num).toInt()),
          notes: $checkedConvert('Notes', (v) => v as String),
          notesApproval: $checkedConvert('NotesApproval', (v) => v as String),
          startDate: $checkedConvert('StartDate', (v) => v as String),
          userId: $checkedConvert('UserId', (v) => v as String),
          status: $checkedConvert('Status', (v) => v as String),
          approveBy: $checkedConvert('ApproveBy', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'approveDate': 'ApproveDate',
        'endDate': 'EndDate',
        'idLeaveRequestType': 'IdLeaveRequestType',
        'notes': 'Notes',
        'notesApproval': 'NotesApproval',
        'startDate': 'StartDate',
        'userId': 'UserId',
        'status': 'Status',
        'approveBy': 'ApproveBy'
      },
    );

Map<String, dynamic> _$CreateLeaveRequestModelToJson(
        CreateLeaveRequestModel instance) =>
    <String, dynamic>{
      'ApproveDate': instance.approveDate,
      'EndDate': instance.endDate,
      'IdLeaveRequestType': instance.idLeaveRequestType,
      'Notes': instance.notes,
      'NotesApproval': instance.notesApproval,
      'StartDate': instance.startDate,
      'UserId': instance.userId,
      'Status': instance.status,
      'ApproveBy': instance.approveBy,
    };

CreateLeaveRequestResponseModel _$CreateLeaveRequestResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateLeaveRequestResponseModel',
      json,
      ($checkedConvert) {
        final val = CreateLeaveRequestResponseModel(
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String),
          description: $checkedConvert('Description', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'code': 'Code',
        'succeeded': 'Succeeded',
        'message': 'Message',
        'description': 'Description'
      },
    );

Map<String, dynamic> _$CreateLeaveRequestResponseModelToJson(
        CreateLeaveRequestResponseModel instance) =>
    <String, dynamic>{
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };
