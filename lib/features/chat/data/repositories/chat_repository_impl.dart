import 'dart:io';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/contact.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_api_response_model.dart';
import '../../../../features/bmi/data/models/bmi_api_response_model.dart';
import '../../../../core/security/security_manager.dart';
import '../../../../core/constants/app_constants.dart';

@injectable
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);
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
    try {
      // Get current user ID
      final currentUserId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('Current user ID not found');
      }

      final request = ListConversationRequestModel(
        userId: currentUserId,
        search: '', // Empty search to get all conversations
        start: 0,
        length: 0, // Get all conversations
      );

      final response = await remoteDataSource.getConversations(request);

      if (response.succeeded == false) {
        throw Exception(response.message ?? 'Failed to get conversations');
      }

      // Get user list to map sender IDs to names
      Map<String, String> senderNameMap = {};
      try {
        final userRequest = UserListRequestModel(
          filter: [FilterModel(field: '', search: '')],
          sort: SortModel(field: 'Fullname', type: 0),
          start: 1,
          length: 0, // Get all users
        );
        final userResponse = await remoteDataSource.getUserList(userRequest);
        if (userResponse.succeeded == true) {
          senderNameMap = {
            for (var user in userResponse.list) user.id: user.fullname
          };
        }
      } catch (e) {
        print('⚠️ Failed to get user list for sender names: $e');
      }

      // Convert ConversationItemModel to Chat entity
      final chats = response.list.map((item) {
        // Determine if last message is from current user
        final isLastMessageFromCurrentUser = 
            item.lastSenderId != null && item.lastSenderId == currentUserId;
        
        // Get sender name for last message
        final lastSenderName = isLastMessageFromCurrentUser
            ? 'Saya'
            : (item.lastSenderId != null 
                ? (senderNameMap[item.lastSenderId] ?? 'User')
                : null);

        return Chat(
          id: item.id,
          name: item.name,
          description: item.description,
          profileImageUrl: item.opponentFoto, // Use OpponentFoto as profile image
          type: ChatType.direct, // Default to direct, can be enhanced later
          participantIds: [], // API doesn't provide participant list
          lastMessageId: item.lastMessageId,
          lastMessageContent: item.lastMessageText,
          lastMessageSenderName: lastSenderName,
          lastMessageTimestamp: item.lastSentAt,
          unreadCount: item.totalUnread, // Use TotalUnread from API response
          isActive: true,
          isOnline: item.isOnline, // Use IsOnline from API response
          opponentFoto: item.opponentFoto, // Store OpponentFoto
          selfFoto: item.selfFoto, // Store SelfFoto
          createdAt: item.lastSentAt ?? DateTime.now(),
          updatedAt: item.lastSentAt ?? DateTime.now(),
        );
      }).toList();

      // Sort by last message timestamp (newest first)
      chats.sort((a, b) {
        if (a.lastMessageTimestamp == null && b.lastMessageTimestamp == null) return 0;
        if (a.lastMessageTimestamp == null) return 1;
        if (b.lastMessageTimestamp == null) return -1;
        return b.lastMessageTimestamp!.compareTo(a.lastMessageTimestamp!);
      });

      return chats;
    } catch (e) {
      print('❌ Error getting conversations: $e');
      // Fallback to dummy data if API fails
      await Future.delayed(const Duration(milliseconds: 500));
      return List.from(_dummyChats);
    }
  }

  @override
  Future<List<Message>> getMessages(String chatId) async {
    try {
      // Get current user ID to include in request
      final currentUserId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      if (currentUserId == null) {
        throw Exception('User ID not found');
      }

      final request = ListMessageRequestModel(
        conversationId: chatId,
        userId: currentUserId,
        start: 0,
        length: 0, // Get all messages
      );

      final response = await remoteDataSource.getMessages(request);

      if (response.succeeded == false) {
        throw Exception(response.message ?? 'Failed to get messages');
      }

      // Get user list to map sender IDs to names (fallback if Header is not available)
      // Try to get sender names from user list
      Map<String, String> senderNameMap = {};
      try {
        final userRequest = UserListRequestModel(
          filter: [FilterModel(field: '', search: '')],
          sort: SortModel(field: 'Fullname', type: 0),
          start: 1,
          length: 0, // Get all users
        );
        final userResponse = await remoteDataSource.getUserList(userRequest);
        if (userResponse.succeeded == true) {
          senderNameMap = {
            for (var user in userResponse.list) user.id: user.fullname
          };
        }
      } catch (e) {
        print('⚠️ Failed to get user list for sender names: $e');
      }

      // Convert MessageItemModel to Message entity
      final messages = response.list.map((item) {
        final isFromCurrentUser = currentUserId != null && item.senderId == currentUserId;
        // Use Header information if available, otherwise fallback to senderNameMap
        final senderName = isFromCurrentUser
            ? 'Saya'
            : (item.header?.fullname ?? senderNameMap[item.senderId] ?? 'User');
        
        // Use Header information for profile image
        // If message is from current user, use SelfFoto, otherwise use OpponentFoto
        final profileImageUrl = isFromCurrentUser
            ? (item.header?.selfFoto)
            : (item.header?.opponentFoto);
        
        // Handle attachments from response
        String? attachmentUrl;
        String? attachmentType;
        if (item.attachments.isNotEmpty) {
          final attachment = item.attachments.first;
          // Use S3Url if available, otherwise build URL from filename
          if (attachment.s3Url != null && attachment.s3Url!.isNotEmpty) {
            attachmentUrl = attachment.s3Url;
          } else {
            // Fallback: build URL from filename
            attachmentUrl = _buildAttachmentUrl(attachment.fileName);
          }
          attachmentType = attachment.fileType;
        }
        
        // Determine message type based on attachments
        MessageType messageType = MessageType.text;
        if (item.attachments.isNotEmpty) {
          final fileType = item.attachments.first.fileType.toLowerCase();
          if (fileType.contains('image')) {
            messageType = MessageType.image;
          } else if (fileType.contains('video')) {
            messageType = MessageType.file; // Can add video type later
          } else {
            messageType = MessageType.file;
          }
        }
        
        return Message(
          id: item.id,
          chatId: item.conversationId,
          senderId: item.senderId,
          senderName: senderName,
          senderProfileImageUrl: profileImageUrl,
          content: item.text ?? '', // Handle null text (for image-only messages)
          type: messageType,
          timestamp: item.sentAt,
          status: MessageStatus.read, // Default to read
          attachmentUrl: attachmentUrl,
          attachmentType: attachmentType,
          // Header information
          isOnline: item.header?.isOnline,
          lastSeen: item.header?.lastSeen,
          opponentFoto: item.header?.opponentFoto,
          selfFoto: item.header?.selfFoto,
          // SentAt from API - indicates message was sent successfully
          sentAt: item.sentAt,
        );
      }).toList();

      // Sort by timestamp (oldest first)
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      return messages;
    } catch (e) {
      print('❌ Error getting messages: $e');
      // Fallback to dummy data if API fails
      await Future.delayed(const Duration(milliseconds: 300));
      return _dummyMessages.where((message) => message.chatId == chatId).toList();
    }
  }

  @override
  Future<List<Contact>> getContacts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_dummyContacts);
  }

  @override
  Future<Message> sendMessage(
      String chatId, String content, MessageType type, {File? attachmentFile}) async {
    try {
      // Get current user ID
      final currentUserId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('Current user ID not found');
      }

      // Support text and image messages (with attachments)
      // If there's an attachment file, allow image type
      if (type != MessageType.text && type != MessageType.image) {
        throw Exception('Only text and image messages are supported');
      }
      
      // If type is image but no attachment file, that's invalid
      if (type == MessageType.image && attachmentFile == null) {
        throw Exception('Image message requires an attachment file');
      }

      // Prepare attachments if file is provided
      List<AttachmentModel>? attachments;
      if (attachmentFile != null && await attachmentFile.exists()) {
        try {
          // Read file as bytes
          final fileBytes = await attachmentFile.readAsBytes();
          
          // Convert to base64
          final base64String = base64Encode(fileBytes);
          
          // Get file name and extension
          final fileName = attachmentFile.path.split(RegExp(r'[\/\\]')).last;
          final fileExtension = fileName.contains('.') 
              ? fileName.split('.').last.toLowerCase() 
              : 'jpg';
          
          // Determine MIME type from extension
          String mimeType = 'image/jpeg'; // default
          if (fileExtension == 'png') {
            mimeType = 'image/png';
          } else if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
            mimeType = 'image/jpeg';
          } else if (fileExtension == 'gif') {
            mimeType = 'image/gif';
          } else if (fileExtension == 'pdf') {
            mimeType = 'application/pdf';
          } else if (fileExtension == 'doc' || fileExtension == 'docx') {
            mimeType = 'application/msword';
          } else if (fileExtension == 'xls' || fileExtension == 'xlsx') {
            mimeType = 'application/vnd.ms-excel';
          }
          
          attachments = [
            AttachmentModel(
              filename: fileName,
              mimeType: mimeType,
              base64: base64String,
              fileSize: fileBytes.length,
            ),
          ];
        } catch (e) {
          print('❌ Error processing attachment: $e');
          throw Exception('Failed to process attachment: $e');
        }
      }

      final request = SendMessageRequestModel(
        conversationId: chatId,
        senderId: currentUserId,
        text: content,
        attachments: attachments,
      );

      final response = await remoteDataSource.sendMessage(request);

      if (response.succeeded == false) {
        throw Exception(response.message ?? 'Failed to send message');
      }

      // Create message entity from response
      // Note: API doesn't return message ID, so we'll create a temporary one
      // In production, you might want to fetch the message list after sending
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
        chatId: chatId,
        senderId: currentUserId,
        senderName: 'Saya',
        senderProfileImageUrl: null,
        content: content,
        type: type,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
        attachmentUrl: null,
        attachmentType: null,
      );

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
    } catch (e) {
      print('❌ Error sending message: $e');
      rethrow;
    }
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

  @override
  Future<List<Contact>> getUsers({String? searchQuery}) async {
    try {
      // Get current user ID to exclude from list
      final currentUserId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      
      // Prepare request for User/list API
      final request = UserListRequestModel(
        filter: searchQuery != null && searchQuery.isNotEmpty
            ? [
                FilterModel(field: 'Fullname', search: searchQuery),
              ]
            : [
                FilterModel(field: '', search: ''),
              ],
        sort: SortModel(field: 'Fullname', type: 0), // 0 = ascending
        start: 1,
        length: 0, // Get all users
      );

      final response = await remoteDataSource.getUserList(request);

      if (response.succeeded == false) {
        throw Exception(response.message ?? 'Failed to get user list');
      }

      // Convert UserListItemModel to Contact
      final contacts = response.list
          .where((user) => currentUserId == null || user.id != currentUserId) // Exclude current user
          .map((user) => Contact(
                id: user.id,
                name: user.fullname,
                phoneNumber: user.phoneNumber,
                email: user.email,
                profileImageUrl: null, // API doesn't provide profile image
                position: user.jabatan,
                department: user.site,
                isOnline: false, // API doesn't provide online status
                lastSeen: null,
                status: null,
              ))
          .toList();

      return contacts;
    } catch (e) {
      print('❌ Error getting users: $e');
      rethrow;
    }
  }

  @override
  Future<String> createConversation(List<String> memberUserIds) async {
    try {
      // Get current user ID and add to member list
      final currentUserId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('Current user ID not found');
      }

      // Filter out empty or invalid user IDs
      final validMemberIds = memberUserIds
          .where((id) => id.isNotEmpty && id != currentUserId)
          .toList();

      // Ensure current user is in the member list
      final allMemberIds = <String>[...validMemberIds];
      if (!allMemberIds.contains(currentUserId)) {
        allMemberIds.add(currentUserId);
      }

      // Ensure we have at least 2 users (current user + at least 1 other)
      if (allMemberIds.length < 2) {
        throw Exception('Conversation requires at least 2 users. Current: ${allMemberIds.length}');
      }

      print('📝 Creating conversation with ${allMemberIds.length} users: $allMemberIds');

      final request = CreateConversationRequestModel(
        memberUserIds: allMemberIds,
      );

      final response = await remoteDataSource.createConversation(request);

      if (response.succeeded == false) {
        throw Exception(response.message ?? 'Failed to create conversation');
      }

      if (response.data == null || response.data!.isEmpty) {
        throw Exception('Conversation ID is empty');
      }

      return response.data!;
    } catch (e) {
      print('❌ Error creating conversation: $e');
      rethrow;
    }
  }

  /// Helper method to build full attachment URL from filename
  String _buildAttachmentUrl(String fileName) {
    if (fileName.isEmpty) {
      return '';
    }
    
    // If already a full URL, return as is
    if (fileName.startsWith('http://') || fileName.startsWith('https://')) {
      return fileName;
    }
    
    // Get base URL
    final baseUrl = AppConstants.baseUrl;
    
    // URL encode the filename to handle special characters
    final encodedFileName = Uri.encodeComponent(fileName);
    
    // Use /api/v1/file/{filename} endpoint
    return '$baseUrl/file/$encodedFileName';
  }
}
