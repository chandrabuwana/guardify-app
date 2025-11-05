class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String? senderProfileImageUrl;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final MessageStatus status;
  final String? attachmentUrl;
  final String? attachmentType;

  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    this.senderProfileImageUrl,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.status,
    this.attachmentUrl,
    this.attachmentType,
  });

  Message copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? senderName,
    String? senderProfileImageUrl,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    MessageStatus? status,
    String? attachmentUrl,
    String? attachmentType,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderProfileImageUrl:
          senderProfileImageUrl ?? this.senderProfileImageUrl,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      attachmentType: attachmentType ?? this.attachmentType,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message &&
        other.id == id &&
        other.chatId == chatId &&
        other.senderId == senderId &&
        other.senderName == senderName &&
        other.senderProfileImageUrl == senderProfileImageUrl &&
        other.content == content &&
        other.type == type &&
        other.timestamp == timestamp &&
        other.status == status &&
        other.attachmentUrl == attachmentUrl &&
        other.attachmentType == attachmentType;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      chatId,
      senderId,
      senderName,
      senderProfileImageUrl,
      content,
      type,
      timestamp,
      status,
      attachmentUrl,
      attachmentType,
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, chatId: $chatId, senderId: $senderId, senderName: $senderName, senderProfileImageUrl: $senderProfileImageUrl, content: $content, type: $type, timestamp: $timestamp, status: $status, attachmentUrl: $attachmentUrl, attachmentType: $attachmentType)';
  }
}

enum MessageType {
  text,
  image,
  voice,
  file,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}
