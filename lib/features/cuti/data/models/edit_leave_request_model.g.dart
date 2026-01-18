// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_leave_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditLeaveRequestModel _$EditLeaveRequestModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'EditLeaveRequestModel',
      json,
      ($checkedConvert) {
        final val = EditLeaveRequestModel(
          approveBy: $checkedConvert('ApproveBy', (v) => v as String),
          approveDate: $checkedConvert('ApproveDate', (v) => v as String),
          createBy: $checkedConvert('CreateBy', (v) => v as String),
          createDate: $checkedConvert('CreateDate', (v) => v as String),
          endDate: $checkedConvert('EndDate', (v) => v as String),
          idLeaveRequestType:
              $checkedConvert('IdLeaveRequestType', (v) => (v as num).toInt()),
          notes: $checkedConvert('Notes', (v) => v as String),
          notesApproval: $checkedConvert('NotesApproval', (v) => v as String),
          startDate: $checkedConvert('StartDate', (v) => v as String),
          status: $checkedConvert('Status', (v) => v as String),
          userId: $checkedConvert('UserId', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'approveBy': 'ApproveBy',
        'approveDate': 'ApproveDate',
        'createBy': 'CreateBy',
        'createDate': 'CreateDate',
        'endDate': 'EndDate',
        'idLeaveRequestType': 'IdLeaveRequestType',
        'notes': 'Notes',
        'notesApproval': 'NotesApproval',
        'startDate': 'StartDate',
        'status': 'Status',
        'userId': 'UserId'
      },
    );

Map<String, dynamic> _$EditLeaveRequestModelToJson(
        EditLeaveRequestModel instance) =>
    <String, dynamic>{
      'ApproveBy': instance.approveBy,
      'ApproveDate': instance.approveDate,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate,
      'EndDate': instance.endDate,
      'IdLeaveRequestType': instance.idLeaveRequestType,
      'Notes': instance.notes,
      'NotesApproval': instance.notesApproval,
      'StartDate': instance.startDate,
      'Status': instance.status,
      'UserId': instance.userId,
    };
