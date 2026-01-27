// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_api_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateConversationRequestModel _$CreateConversationRequestModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateConversationRequestModel',
      json,
      ($checkedConvert) {
        final val = CreateConversationRequestModel(
          memberUserIds: $checkedConvert('MemberUserIds',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
      fieldKeyMap: const {'memberUserIds': 'MemberUserIds'},
    );

Map<String, dynamic> _$CreateConversationRequestModelToJson(
        CreateConversationRequestModel instance) =>
    <String, dynamic>{
      'MemberUserIds': instance.memberUserIds,
    };

CreateConversationResponseModel _$CreateConversationResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateConversationResponseModel',
      json,
      ($checkedConvert) {
        final val = CreateConversationResponseModel(
          data: $checkedConvert('Data', (v) => v as String?),
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String),
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

Map<String, dynamic> _$CreateConversationResponseModelToJson(
        CreateConversationResponseModel instance) =>
    <String, dynamic>{
      'Data': instance.data,
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

SendMessageRequestModel _$SendMessageRequestModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SendMessageRequestModel',
      json,
      ($checkedConvert) {
        final val = SendMessageRequestModel(
          conversationId: $checkedConvert('ConversationId', (v) => v as String),
          senderId: $checkedConvert('SenderId', (v) => v as String),
          text: $checkedConvert('Text', (v) => v as String),
          attachments: $checkedConvert(
              'Attachments',
              (v) => (v as List<dynamic>?)
                  ?.map((e) =>
                      AttachmentModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'conversationId': 'ConversationId',
        'senderId': 'SenderId',
        'text': 'Text',
        'attachments': 'Attachments'
      },
    );

Map<String, dynamic> _$SendMessageRequestModelToJson(
        SendMessageRequestModel instance) =>
    <String, dynamic>{
      'ConversationId': instance.conversationId,
      'SenderId': instance.senderId,
      'Text': instance.text,
      'Attachments': instance.attachments?.map((e) => e.toJson()).toList(),
    };

AttachmentModel _$AttachmentModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AttachmentModel',
      json,
      ($checkedConvert) {
        final val = AttachmentModel(
          filename: $checkedConvert('Filename', (v) => v as String),
          mimeType: $checkedConvert('MimeType', (v) => v as String),
          base64: $checkedConvert('Base64', (v) => v as String),
          fileSize: $checkedConvert('FileSize', (v) => (v as num).toInt()),
        );
        return val;
      },
      fieldKeyMap: const {
        'filename': 'Filename',
        'mimeType': 'MimeType',
        'base64': 'Base64',
        'fileSize': 'FileSize'
      },
    );

Map<String, dynamic> _$AttachmentModelToJson(AttachmentModel instance) =>
    <String, dynamic>{
      'Filename': instance.filename,
      'MimeType': instance.mimeType,
      'Base64': instance.base64,
      'FileSize': instance.fileSize,
    };

SendMessageResponseModel _$SendMessageResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SendMessageResponseModel',
      json,
      ($checkedConvert) {
        final val = SendMessageResponseModel(
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

Map<String, dynamic> _$SendMessageResponseModelToJson(
        SendMessageResponseModel instance) =>
    <String, dynamic>{
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

ListMessageRequestModel _$ListMessageRequestModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ListMessageRequestModel',
      json,
      ($checkedConvert) {
        final val = ListMessageRequestModel(
          conversationId: $checkedConvert('ConversationId', (v) => v as String),
          userId: $checkedConvert('UserId', (v) => v as String),
          start: $checkedConvert('Start', (v) => (v as num).toInt()),
          length: $checkedConvert('Length', (v) => (v as num).toInt()),
        );
        return val;
      },
      fieldKeyMap: const {
        'conversationId': 'ConversationId',
        'userId': 'UserId',
        'start': 'Start',
        'length': 'Length'
      },
    );

Map<String, dynamic> _$ListMessageRequestModelToJson(
        ListMessageRequestModel instance) =>
    <String, dynamic>{
      'ConversationId': instance.conversationId,
      'UserId': instance.userId,
      'Start': instance.start,
      'Length': instance.length,
    };

ListMessageResponseModel _$ListMessageResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ListMessageResponseModel',
      json,
      ($checkedConvert) {
        final val = ListMessageResponseModel(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      MessageItemModel.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$ListMessageResponseModelToJson(
        ListMessageResponseModel instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

MessageItemModel _$MessageItemModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MessageItemModel',
      json,
      ($checkedConvert) {
        final val = MessageItemModel(
          id: $checkedConvert('Id', (v) => v as String),
          conversationId: $checkedConvert('ConversationId', (v) => v as String),
          senderId: $checkedConvert('SenderId', (v) => v as String),
          text: $checkedConvert('Text', (v) => v as String),
          sentAt: $checkedConvert('SentAt', (v) => DateTime.parse(v as String)),
          attachments: $checkedConvert(
              'Attachments',
              (v) => (v as List<dynamic>)
                  .map((e) => MessageAttachmentModel.fromJson(
                      e as Map<String, dynamic>))
                  .toList()),
          header: $checkedConvert(
              'Header',
              (v) => v == null
                  ? null
                  : MessageHeaderModel.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'conversationId': 'ConversationId',
        'senderId': 'SenderId',
        'text': 'Text',
        'sentAt': 'SentAt',
        'attachments': 'Attachments',
        'header': 'Header'
      },
    );

Map<String, dynamic> _$MessageItemModelToJson(MessageItemModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'ConversationId': instance.conversationId,
      'SenderId': instance.senderId,
      'Text': instance.text,
      'SentAt': instance.sentAt.toIso8601String(),
      'Attachments': instance.attachments.map((e) => e.toJson()).toList(),
      'Header': instance.header?.toJson(),
    };

MessageAttachmentModel _$MessageAttachmentModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'MessageAttachmentModel',
      json,
      ($checkedConvert) {
        final val = MessageAttachmentModel(
          id: $checkedConvert('Id', (v) => v as String),
          fileName: $checkedConvert('FileName', (v) => v as String),
          fileType: $checkedConvert('FileType', (v) => v as String),
          fileSize: $checkedConvert('FileSize', (v) => (v as num).toInt()),
          s3Url: $checkedConvert('S3Url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'fileName': 'FileName',
        'fileType': 'FileType',
        'fileSize': 'FileSize',
        's3Url': 'S3Url'
      },
    );

Map<String, dynamic> _$MessageAttachmentModelToJson(
        MessageAttachmentModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'FileName': instance.fileName,
      'FileType': instance.fileType,
      'FileSize': instance.fileSize,
      'S3Url': instance.s3Url,
    };

MessageHeaderModel _$MessageHeaderModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MessageHeaderModel',
      json,
      ($checkedConvert) {
        final val = MessageHeaderModel(
          id: $checkedConvert('Id', (v) => v as String),
          fullname: $checkedConvert('Fullname', (v) => v as String),
          lastSeen: $checkedConvert('LastSeen',
              (v) => v == null ? null : DateTime.parse(v as String)),
          isOnline: $checkedConvert('IsOnline', (v) => v as bool),
          opponentFoto: $checkedConvert('OpponentFoto', (v) => v as String?),
          selfFoto: $checkedConvert('SelfFoto', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'fullname': 'Fullname',
        'lastSeen': 'LastSeen',
        'isOnline': 'IsOnline',
        'opponentFoto': 'OpponentFoto',
        'selfFoto': 'SelfFoto'
      },
    );

Map<String, dynamic> _$MessageHeaderModelToJson(MessageHeaderModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Fullname': instance.fullname,
      'LastSeen': instance.lastSeen?.toIso8601String(),
      'IsOnline': instance.isOnline,
      'OpponentFoto': instance.opponentFoto,
      'SelfFoto': instance.selfFoto,
    };

ListConversationRequestModel _$ListConversationRequestModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ListConversationRequestModel',
      json,
      ($checkedConvert) {
        final val = ListConversationRequestModel(
          userId: $checkedConvert('UserId', (v) => v as String),
          search: $checkedConvert('Search', (v) => v as String),
          start: $checkedConvert('Start', (v) => (v as num).toInt()),
          length: $checkedConvert('Length', (v) => (v as num).toInt()),
        );
        return val;
      },
      fieldKeyMap: const {
        'userId': 'UserId',
        'search': 'Search',
        'start': 'Start',
        'length': 'Length'
      },
    );

Map<String, dynamic> _$ListConversationRequestModelToJson(
        ListConversationRequestModel instance) =>
    <String, dynamic>{
      'UserId': instance.userId,
      'Search': instance.search,
      'Start': instance.start,
      'Length': instance.length,
    };

ListConversationResponseModel _$ListConversationResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ListConversationResponseModel',
      json,
      ($checkedConvert) {
        final val = ListConversationResponseModel(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      ConversationItemModel.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$ListConversationResponseModelToJson(
        ListConversationResponseModel instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

ConversationItemModel _$ConversationItemModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ConversationItemModel',
      json,
      ($checkedConvert) {
        final val = ConversationItemModel(
          id: $checkedConvert('Id', (v) => v as String),
          name: $checkedConvert('Name', (v) => v as String),
          description: $checkedConvert('Description', (v) => v as String?),
          lastMessageId: $checkedConvert('LastMessageId', (v) => v as String?),
          lastSenderId: $checkedConvert('LastSenderId', (v) => v as String?),
          lastMessageText:
              $checkedConvert('LastMessageText', (v) => v as String?),
          lastSentAt: $checkedConvert('LastSentAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
          lastMessageAttachmentCount: $checkedConvert(
              'LastMessageAttachmentCount', (v) => (v as num?)?.toInt() ?? 0),
          totalUnread:
              $checkedConvert('TotalUnread', (v) => (v as num?)?.toInt() ?? 0),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'name': 'Name',
        'description': 'Description',
        'lastMessageId': 'LastMessageId',
        'lastSenderId': 'LastSenderId',
        'lastMessageText': 'LastMessageText',
        'lastSentAt': 'LastSentAt',
        'lastMessageAttachmentCount': 'LastMessageAttachmentCount',
        'totalUnread': 'TotalUnread'
      },
    );

Map<String, dynamic> _$ConversationItemModelToJson(
        ConversationItemModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Description': instance.description,
      'LastMessageId': instance.lastMessageId,
      'LastSenderId': instance.lastSenderId,
      'LastMessageText': instance.lastMessageText,
      'LastSentAt': instance.lastSentAt?.toIso8601String(),
      'LastMessageAttachmentCount': instance.lastMessageAttachmentCount,
      'TotalUnread': instance.totalUnread,
    };
