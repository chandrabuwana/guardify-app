class Chat {
  final String id;
  final String name;
  final String? description;
  final String? profileImageUrl;
  final ChatType type;
  final List<String> participantIds;
  final String? lastMessageId;
  final String? lastMessageContent;
  final String? lastMessageSenderName;
  final DateTime? lastMessageTimestamp;
  final int unreadCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Chat({
    required this.id,
    required this.name,
    this.description,
    this.profileImageUrl,
    required this.type,
    required this.participantIds,
    this.lastMessageId,
    this.lastMessageContent,
    this.lastMessageSenderName,
    this.lastMessageTimestamp,
    required this.unreadCount,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  Chat copyWith({
    String? id,
    String? name,
    String? description,
    String? profileImageUrl,
    ChatType? type,
    List<String>? participantIds,
    String? lastMessageId,
    String? lastMessageContent,
    String? lastMessageSenderName,
    DateTime? lastMessageTimestamp,
    int? unreadCount,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      type: type ?? this.type,
      participantIds: participantIds ?? this.participantIds,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageSenderName:
          lastMessageSenderName ?? this.lastMessageSenderName,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      unreadCount: unreadCount ?? this.unreadCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Chat &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.profileImageUrl == profileImageUrl &&
        other.type == type &&
        other.participantIds == participantIds &&
        other.lastMessageId == lastMessageId &&
        other.lastMessageContent == lastMessageContent &&
        other.lastMessageSenderName == lastMessageSenderName &&
        other.lastMessageTimestamp == lastMessageTimestamp &&
        other.unreadCount == unreadCount &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      profileImageUrl,
      type,
      participantIds,
      lastMessageId,
      lastMessageContent,
      lastMessageSenderName,
      lastMessageTimestamp,
      unreadCount,
      isActive,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'Chat(id: $id, name: $name, description: $description, profileImageUrl: $profileImageUrl, type: $type, participantIds: $participantIds, lastMessageId: $lastMessageId, lastMessageContent: $lastMessageContent, lastMessageSenderName: $lastMessageSenderName, lastMessageTimestamp: $lastMessageTimestamp, unreadCount: $unreadCount, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

enum ChatType {
  direct,
  group,
}
