import 'dart:io';
import '../entities/chat.dart';
import '../entities/message.dart';
import '../entities/contact.dart';

abstract class ChatRepository {
  Future<List<Chat>> getChats();
  Future<List<Message>> getMessages(String chatId);
  Future<List<Contact>> getContacts();
  Future<Message> sendMessage(String chatId, String content, MessageType type, {File? attachmentFile});
  Future<void> markMessagesAsRead(String chatId);
  Future<Chat> createChat(
      List<String> participantIds, String name, ChatType type);
  Future<List<Message>> searchMessages(String query);
  Future<List<Chat>> searchChats(String query);
  
  // New methods for API integration
  Future<List<Contact>> getUsers({String? searchQuery});
  Future<String> createConversation(List<String> memberUserIds);
}
