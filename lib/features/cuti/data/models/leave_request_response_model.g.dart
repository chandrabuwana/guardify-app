// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveRequestResponseModel _$LeaveRequestResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'LeaveRequestResponseModel',
      json,
      ($checkedConvert) {
        final val = LeaveRequestResponseModel(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      LeaveRequestItemModel.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$LeaveRequestResponseModelToJson(
        LeaveRequestResponseModel instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

LeaveRequestItemModel _$LeaveRequestItemModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'LeaveRequestItemModel',
      json,
      ($checkedConvert) {
        final val = LeaveRequestItemModel(
          id: $checkedConvert('Id', (v) => v as String),
          createBy: $checkedConvert('CreateBy', (v) => v as String?),
          createDate: $checkedConvert('CreateDate', (v) => v as String?),
          endDate: $checkedConvert('EndDate', (v) => v as String),
          fullname: $checkedConvert('Fullname', (v) => v as String?),
          idLeaveRequestType:
              $checkedConvert('IdLeaveRequestType', (v) => (v as num).toInt()),
          leaveRequestType: $checkedConvert(
              'LeaveRequestType',
              (v) => v == null
                  ? null
                  : LeaveRequestTypeModel.fromJson(v as Map<String, dynamic>)),
          nip: $checkedConvert('Nip', (v) => v as String?),
          notes: $checkedConvert('Notes', (v) => v as String?),
          notesApproval: $checkedConvert('NotesApproval', (v) => v as String?),
          startDate: $checkedConvert('StartDate', (v) => v as String),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate', (v) => v as String?),
          userId: $checkedConvert('UserId', (v) => v as String),
          user: $checkedConvert(
              'User',
              (v) => v == null
                  ? null
                  : UserLeaveModel.fromJson(v as Map<String, dynamic>)),
          status: $checkedConvert('Status', (v) => v as String?),
          approveBy: $checkedConvert('ApproveBy', (v) => v as String?),
          approveDate: $checkedConvert('ApproveDate', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'createBy': 'CreateBy',
        'createDate': 'CreateDate',
        'endDate': 'EndDate',
        'fullname': 'Fullname',
        'idLeaveRequestType': 'IdLeaveRequestType',
        'leaveRequestType': 'LeaveRequestType',
        'nip': 'Nip',
        'notes': 'Notes',
        'notesApproval': 'NotesApproval',
        'startDate': 'StartDate',
        'updateBy': 'UpdateBy',
        'updateDate': 'UpdateDate',
        'userId': 'UserId',
        'user': 'User',
        'status': 'Status',
        'approveBy': 'ApproveBy',
        'approveDate': 'ApproveDate'
      },
    );

Map<String, dynamic> _$LeaveRequestItemModelToJson(
        LeaveRequestItemModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate,
      'EndDate': instance.endDate,
      'Fullname': instance.fullname,
      'IdLeaveRequestType': instance.idLeaveRequestType,
      'LeaveRequestType': instance.leaveRequestType?.toJson(),
      'Nip': instance.nip,
      'Notes': instance.notes,
      'NotesApproval': instance.notesApproval,
      'StartDate': instance.startDate,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate,
      'UserId': instance.userId,
      'User': instance.user?.toJson(),
      'Status': instance.status,
      'ApproveBy': instance.approveBy,
      'ApproveDate': instance.approveDate,
    };

UserLeaveModel _$UserLeaveModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserLeaveModel',
      json,
      ($checkedConvert) {
        final val = UserLeaveModel(
          id: $checkedConvert('Id', (v) => v as String),
          username: $checkedConvert('Username', (v) => v as String?),
          fullname: $checkedConvert('Fullname', (v) => v as String?),
          email: $checkedConvert('Email', (v) => v as String?),
          phoneNumber: $checkedConvert('PhoneNumber', (v) => v as String?),
          status: $checkedConvert('Status', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'username': 'Username',
        'fullname': 'Fullname',
        'email': 'Email',
        'phoneNumber': 'PhoneNumber',
        'status': 'Status'
      },
    );

Map<String, dynamic> _$UserLeaveModelToJson(UserLeaveModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Username': instance.username,
      'Fullname': instance.fullname,
      'Email': instance.email,
      'PhoneNumber': instance.phoneNumber,
      'Status': instance.status,
    };
