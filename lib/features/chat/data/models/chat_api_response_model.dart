import 'package:json_annotation/json_annotation.dart';

part 'chat_api_response_model.g.dart';

/// Request model untuk Create Conversation API
@JsonSerializable()
class CreateConversationRequestModel {
  @JsonKey(name: 'MemberUserIds')
  final List<String> memberUserIds;

  CreateConversationRequestModel({
    required this.memberUserIds,
  });

  factory CreateConversationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateConversationRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateConversationRequestModelToJson(this);
}

/// Response model untuk Create Conversation API
@JsonSerializable()
class CreateConversationResponseModel {
  @JsonKey(name: 'Data')
  final String? data; // Conversation ID

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  CreateConversationResponseModel({
    this.data,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory CreateConversationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreateConversationResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateConversationResponseModelToJson(this);
}

/// Request model untuk Send Message API
@JsonSerializable()
class SendMessageRequestModel {
  @JsonKey(name: 'ConversationId')
  final String conversationId;

  @JsonKey(name: 'SenderId')
  final String senderId;

  @JsonKey(name: 'Text')
  final String text;

  @JsonKey(name: 'Attachments')
  final List<AttachmentModel>? attachments;

  SendMessageRequestModel({
    required this.conversationId,
    required this.senderId,
    required this.text,
    this.attachments,
  });

  factory SendMessageRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageRequestModelToJson(this);
}

/// Model untuk Attachment dalam Send Message Request
@JsonSerializable()
class AttachmentModel {
  @JsonKey(name: 'Filename')
  final String filename;

  @JsonKey(name: 'MimeType')
  final String mimeType;

  @JsonKey(name: 'Base64')
  final String base64;

  @JsonKey(name: 'FileSize')
  final int fileSize;

  AttachmentModel({
    required this.filename,
    required this.mimeType,
    required this.base64,
    required this.fileSize,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$AttachmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentModelToJson(this);
}

/// Response model untuk Send Message API
@JsonSerializable()
class SendMessageResponseModel {
  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  SendMessageResponseModel({
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageResponseModelToJson(this);
}

/// Request model untuk List Message API
@JsonSerializable()
class ListMessageRequestModel {
  @JsonKey(name: 'ConversationId')
  final String conversationId;

  @JsonKey(name: 'Start')
  final int start;

  @JsonKey(name: 'Length')
  final int length;

  ListMessageRequestModel({
    required this.conversationId,
    required this.start,
    required this.length,
  });

  factory ListMessageRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ListMessageRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListMessageRequestModelToJson(this);
}

/// Response model untuk List Message API
@JsonSerializable()
class ListMessageResponseModel {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<MessageItemModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  ListMessageResponseModel({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory ListMessageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ListMessageResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListMessageResponseModelToJson(this);
}

/// Model untuk item message dalam List Message API
@JsonSerializable()
class MessageItemModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'ConversationId')
  final String conversationId;

  @JsonKey(name: 'SenderId')
  final String senderId;

  @JsonKey(name: 'Text')
  final String text;

  @JsonKey(name: 'SentAt')
  final DateTime sentAt;

  @JsonKey(name: 'Attachments')
  final List<MessageAttachmentModel> attachments;

  MessageItemModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.sentAt,
    required this.attachments,
  });

  factory MessageItemModel.fromJson(Map<String, dynamic> json) =>
      _$MessageItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageItemModelToJson(this);
}

/// Model untuk Attachment dalam Message Response (List Message API)
@JsonSerializable()
class MessageAttachmentModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'FileName')
  final String fileName;

  @JsonKey(name: 'FileType')
  final String fileType;

  @JsonKey(name: 'FileSize')
  final int fileSize;

  @JsonKey(name: 'S3Url')
  final String? s3Url;

  MessageAttachmentModel({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    this.s3Url,
  });

  factory MessageAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$MessageAttachmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageAttachmentModelToJson(this);
}

/// Request model untuk List Conversation API
@JsonSerializable()
class ListConversationRequestModel {
  @JsonKey(name: 'UserId')
  final String userId;

  @JsonKey(name: 'Search')
  final String search;

  @JsonKey(name: 'Start')
  final int start;

  @JsonKey(name: 'Length')
  final int length;

  ListConversationRequestModel({
    required this.userId,
    required this.search,
    required this.start,
    required this.length,
  });

  factory ListConversationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ListConversationRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListConversationRequestModelToJson(this);
}

/// Response model untuk List Conversation API
@JsonSerializable()
class ListConversationResponseModel {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<ConversationItemModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  ListConversationResponseModel({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory ListConversationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ListConversationResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListConversationResponseModelToJson(this);
}

/// Model untuk item conversation dalam List Conversation API
@JsonSerializable()
class ConversationItemModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Description')
  final String? description;

  @JsonKey(name: 'LastMessageId')
  final String? lastMessageId;

  @JsonKey(name: 'LastSenderId')
  final String? lastSenderId;

  @JsonKey(name: 'LastMessageText')
  final String? lastMessageText;

  @JsonKey(name: 'LastSentAt')
  final DateTime? lastSentAt;

  @JsonKey(name: 'LastMessageAttachmentCount')
  final int lastMessageAttachmentCount;

  ConversationItemModel({
    required this.id,
    required this.name,
    this.description,
    this.lastMessageId,
    this.lastSenderId,
    this.lastMessageText,
    this.lastSentAt,
    this.lastMessageAttachmentCount = 0,
  });

  factory ConversationItemModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationItemModelToJson(this);
}
