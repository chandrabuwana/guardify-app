import 'package:injectable/injectable.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/contact.dart';
import '../../domain/repositories/chat_repository.dart';

@injectable
class ChatRepositoryImpl implements ChatRepository {
  // Dummy data for demonstration
  static final List<Chat> _dummyChats = [
    Chat(
      id: '1',
      name: 'Aiman Hafiz - 8339002',
      profileImageUrl: null,
      type: ChatType.direct,
      participantIds: ['current_user', 'user_1'],
      lastMessageContent: 'Ok Siap',
      lastMessageSenderName: 'Aiman Hafiz',
      lastMessageTimestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 1,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Chat(
      id: '2',
      name: 'Grup Pos Gajah',
      profileImageUrl: null,
      type: ChatType.group,
      participantIds: ['current_user', 'user_2', 'user_3', 'user_4'],
      lastMessageContent: 'Iwan: otw',
      lastMessageSenderName: 'Iwan',
      lastMessageTimestamp:
          DateTime.now().subtract(const Duration(minutes: 15)),
      unreadCount: 1,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    Chat(
      id: '3',
      name: 'Grup Danton A',
      profileImageUrl: null,
      type: ChatType.group,
      participantIds: ['current_user', 'user_5', 'user_6', 'user_7'],
      lastMessageContent: 'Aman',
      lastMessageSenderName: 'Danton A',
      lastMessageTimestamp: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 1,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Chat(
      id: '4',
      name: 'Grup Pos Macan',
      profileImageUrl: null,
      type: ChatType.group,
      participantIds: ['current_user', 'user_8', 'user_9'],
      lastMessageContent: 'Berangkat',
      lastMessageSenderName: 'Pos Macan',
      lastMessageTimestamp: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 1,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Chat(
      id: '5',
      name: 'Grup Patroli',
      profileImageUrl: null,
      type: ChatType.group,
      participantIds: ['current_user', 'user_10', 'user_11', 'user_12'],
      lastMessageContent: 'Paron: Baik Pak',
      lastMessageSenderName: 'Paron',
      lastMessageTimestamp: DateTime.now().subtract(const Duration(hours: 3)),
      unreadCount: 1,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  static final List<Message> _dummyMessages = [
    // Messages for chat with Aiman Hafiz
    Message(
      id: '1',
      chatId: '1',
      senderId: 'user_1',
      senderName: 'Aiman Hafiz',
      content: 'Posisi dimana pak? Apakah aman?',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      status: MessageStatus.read,
    ),
    Message(
      id: '2',
      chatId: '1',
      senderId: 'current_user',
      senderName: 'Saya',
      content: 'Saya di Pos Gajah, aman terkendali',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      status: MessageStatus.read,
    ),
    Message(
      id: '3',
      chatId: '1',
      senderId: 'user_1',
      senderName: 'Aiman Hafiz',
      content: 'Apakah sudah selesai patroli rute A?',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      status: MessageStatus.read,
    ),
    Message(
      id: '4',
      chatId: '1',
      senderId: 'current_user',
      senderName: 'Saya',
      content:
          'Sudah pak, pengecekan lengkap di 6 lokasi aman semua. Dokumentasi sudah dikirim ke sistem.',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
      status: MessageStatus.read,
    ),
    Message(
      id: '5',
      chatId: '1',
      senderId: 'user_1',
      senderName: 'Aiman Hafiz',
      content: 'Ok ok pak copy, saya pulang dulu',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      status: MessageStatus.read,
    ),
    Message(
      id: '6',
      chatId: '1',
      senderId: 'current_user',
      senderName: 'Saya',
      content: 'Iyaa hati hati pak, happy weekend!',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      status: MessageStatus.read,
    ),
    Message(
      id: '7',
      chatId: '1',
      senderId: 'user_1',
      senderName: 'Aiman Hafiz',
      content: 'Ok Siap',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      status: MessageStatus.delivered,
    ),
  ];

  static final List<Contact> _dummyContacts = [
    Contact(
      id: 'user_1',
      name: 'Aiman Hafiz',
      phoneNumber: '081234567890',
      position: 'Security Guard',
      department: 'Security',
      isOnline: true,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 18)),
      status: 'Aktif 18 menit yang lalu',
    ),
    Contact(
      id: 'user_2',
      name: 'Iwan',
      phoneNumber: '081234567891',
      position: 'Security Guard',
      department: 'Security',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      status: 'Terakhir aktif 2 jam yang lalu',
    ),
    Contact(
      id: 'user_3',
      name: 'Danton A',
      phoneNumber: '081234567892',
      position: 'Team Leader',
      department: 'Security',
      isOnline: true,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
      status: 'Aktif 5 menit yang lalu',
    ),
    Contact(
      id: 'user_4',
      name: 'Pos Macan',
      phoneNumber: '081234567893',
      position: 'Security Guard',
      department: 'Security',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
      status: 'Terakhir aktif 1 jam yang lalu',
    ),
    Contact(
      id: 'user_5',
      name: 'Paron',
      phoneNumber: '081234567894',
      position: 'Security Guard',
      department: 'Security',
      isOnline: true,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 10)),
      status: 'Aktif 10 menit yang lalu',
    ),
  ];

  @override
  Future<List<Chat>> getChats() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_dummyChats);
  }

  @override
  Future<List<Message>> getMessages(String chatId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _dummyMessages.where((message) => message.chatId == chatId).toList();
  }

  @override
  Future<List<Contact>> getContacts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_dummyContacts);
  }

  @override
  Future<Message> sendMessage(
      String chatId, String content, MessageType type) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      senderId: 'current_user',
      senderName: 'Saya',
      content: content,
      type: type,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    // Add to dummy messages
    _dummyMessages.add(newMessage);

    // Update chat's last message
    final chatIndex = _dummyChats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      _dummyChats[chatIndex] = _dummyChats[chatIndex].copyWith(
        lastMessageId: newMessage.id,
        lastMessageContent: content,
        lastMessageSenderName: 'Saya',
        lastMessageTimestamp: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    return newMessage;
  }

  @override
  Future<void> markMessagesAsRead(String chatId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    // Update unread count to 0
    final chatIndex = _dummyChats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      _dummyChats[chatIndex] = _dummyChats[chatIndex].copyWith(
        unreadCount: 0,
      );
    }
  }

  @override
  Future<Chat> createChat(
      List<String> participantIds, String name, ChatType type) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));

    final newChat = Chat(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      type: type,
      participantIds: participantIds,
      unreadCount: 0,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _dummyChats.add(newChat);
    return newChat;
  }

  @override
  Future<List<Message>> searchMessages(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    return _dummyMessages
        .where((message) =>
            message.content.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<List<Chat>> searchChats(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    return _dummyChats
        .where((chat) => chat.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
