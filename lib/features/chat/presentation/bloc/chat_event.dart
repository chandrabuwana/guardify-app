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

  const ChatSendMessage({
    required this.chatId,
    required this.content,
    required this.type,
  });

  @override
  List<Object?> get props => [chatId, content, type];
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
