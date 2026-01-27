import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/chat.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatLoadChats extends ChatEvent {
  const ChatLoadChats();
}

class ChatLoadMessages extends ChatEvent {
  final String chatId;

  const ChatLoadMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ChatSendMessage extends ChatEvent {
  final String chatId;
  final String content;
  final MessageType type;
  final File? attachmentFile;

  const ChatSendMessage({
    required this.chatId,
    required this.content,
    required this.type,
    this.attachmentFile,
  });

  @override
  List<Object?> get props => [chatId, content, type, attachmentFile];
}

class ChatLoadContacts extends ChatEvent {
  const ChatLoadContacts();
}

class ChatMarkAsRead extends ChatEvent {
  final String chatId;

  const ChatMarkAsRead(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ChatSearchMessages extends ChatEvent {
  final String query;

  const ChatSearchMessages(this.query);

  @override
  List<Object?> get props => [query];
}

class ChatSearchChats extends ChatEvent {
  final String query;

  const ChatSearchChats(this.query);

  @override
  List<Object?> get props => [query];
}

class ChatCreateChat extends ChatEvent {
  final List<String> participantIds;
  final String name;
  final ChatType type;

  const ChatCreateChat({
    required this.participantIds,
    required this.name,
    required this.type,
  });

  @override
  List<Object?> get props => [participantIds, name, type];
}

class ChatSelectChat extends ChatEvent {
  final String chatId;

  const ChatSelectChat(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ChatClearSearch extends ChatEvent {
  const ChatClearSearch();
}

class ChatClearError extends ChatEvent {
  const ChatClearError();
}

class ChatLoadUsers extends ChatEvent {
  final String? searchQuery;

  const ChatLoadUsers({this.searchQuery});

  @override
  List<Object?> get props => [searchQuery];
}

class ChatCreateConversation extends ChatEvent {
  final List<String> memberUserIds;

  const ChatCreateConversation({required this.memberUserIds});

  @override
  List<Object?> get props => [memberUserIds];
}

class ChatJoinConversation extends ChatEvent {
  final String conversationId;
  final String userId;

  const ChatJoinConversation({
    required this.conversationId,
    required this.userId,
  });

  @override
  List<Object?> get props => [conversationId, userId];
}

class ChatLeaveConversation extends ChatEvent {
  final String conversationId;
  final String userId;

  const ChatLeaveConversation({
    required this.conversationId,
    required this.userId,
  });

  @override
  List<Object?> get props => [conversationId, userId];
}

class ChatMessageReceived extends ChatEvent {
  final Message message;

  const ChatMessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}