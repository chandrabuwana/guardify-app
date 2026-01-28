import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/contact.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../data/services/signalr_chat_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/security_manager.dart';
import 'chat_event.dart';
import 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final SignalRChatService signalRService;
  StreamSubscription<Message>? _messageSubscription;
  StreamSubscription<ConnectionState>? _connectionSubscription;
  
  // Cache untuk user names (senderId -> senderName)
  Map<String, String> _userNameCache = {};
  bool _isLoadingUserNames = false;

  ChatBloc(
    this.chatRepository,
    this.signalRService,
  ) : super(ChatState.initial()) {
    on<ChatLoadChats>(_onLoadChats);
    on<ChatLoadMessages>(_onLoadMessages);
    on<ChatSendMessage>(_onSendMessage);
    on<ChatLoadContacts>(_onLoadContacts);
    on<ChatMarkAsRead>(_onMarkAsRead);
    on<ChatSearchMessages>(_onSearchMessages);
    on<ChatSearchChats>(_onSearchChats);
    on<ChatCreateChat>(_onCreateChat);
    on<ChatSelectChat>(_onSelectChat);
    on<ChatClearSearch>(_onClearSearch);
    on<ChatClearError>(_onClearError);
    on<ChatLoadUsers>(_onLoadUsers);
    on<ChatCreateConversation>(_onCreateConversation);
    on<ChatJoinConversation>(_onJoinConversation);
    on<ChatLeaveConversation>(_onLeaveConversation);
    on<ChatMessageReceived>(_onMessageReceived);

    // Setup SignalR listeners
    _setupSignalRListeners();
    
    // Auto-connect SignalR when ChatBloc is created
    _initializeSignalR();
  }

  /// Initialize SignalR connection
  Future<void> _initializeSignalR() async {
    try {
      if (!signalRService.isConnected) {
        await signalRService.connect();
        print('✅ SignalR auto-connected in ChatBloc');
      }
    } catch (e) {
      print('⚠️ Failed to auto-connect SignalR: $e');
      // Don't throw, just log - connection will retry automatically
    }
  }

  /// Setup SignalR message listeners
  void _setupSignalRListeners() {
    // Listen untuk incoming messages
    _messageSubscription = signalRService.messageStream.listen(
      (message) {
        add(ChatMessageReceived(message));
      },
      onError: (error) {
        print('❌ Error in SignalR message stream: $error');
      },
    );

    // Listen untuk connection state changes
    _connectionSubscription = signalRService.connectionStateStream.listen(
      (connectionState) {
        print('🔵 SignalR connection state: $connectionState');
        // Bisa emit state untuk connection status jika diperlukan
      },
      onError: (error) {
        print('❌ Error in SignalR connection stream: $error');
      },
    );
  }

  Future<void> _onLoadChats(
    ChatLoadChats event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final chats = await chatRepository.getChats();
      emit(state.copyWith(
        isLoading: false,
        chats: chats,
        filteredChats: chats,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat daftar chat: ${e.toString()}',
      ));
    }
  }

  /// Pre-load user names to cache when loading messages
  Future<void> _preloadUserNames() async {
    if (_userNameCache.isNotEmpty || _isLoadingUserNames) {
      return; // Already loaded or loading
    }

    try {
      _isLoadingUserNames = true;
      print('📋 [Hybrid] Pre-loading user names to cache...');
      
      final users = await chatRepository.getUsers();
      for (var user in users) {
        _userNameCache[user.id] = user.name;
      }
      
      // Add current user to cache
      final currentUserId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      if (currentUserId != null) {
        _userNameCache[currentUserId] = 'Saya';
      }
      
      print('✅ [Hybrid] Pre-loaded ${_userNameCache.length} user names to cache');
      _isLoadingUserNames = false;
    } catch (e) {
      print('⚠️ [Hybrid] Error pre-loading user names: $e');
      _isLoadingUserNames = false;
    }
  }

  Future<void> _onLoadMessages(
    ChatLoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoadingMessages: true, errorMessage: null));

    try {
      // Pre-load user names to cache for SignalR messages
      await _preloadUserNames();
      
      final messages = await chatRepository.getMessages(event.chatId);
      emit(state.copyWith(
        isLoadingMessages: false,
        messages: messages,
        selectedChatId: event.chatId,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMessages: false,
        errorMessage: 'Gagal memuat pesan: ${e.toString()}',
      ));
    }
  }

  /// Hybrid approach: Send via API for persistence, update UI via SignalR only
  /// This prevents duplicate messages - UI only updates from SignalR stream
  /// BUT: For messages with attachments, we do optimistic update to show local file immediately
  Future<void> _onSendMessage(
    ChatSendMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      print('📤 [Hybrid] Sending message via API...');
      
      // For messages with attachments, add optimistic update to show local file immediately
      if (event.attachmentFile != null && state.selectedChatId == event.chatId) {
        final currentUserId = await SecurityManager.readSecurely(AppConstants.userIdKey);
        if (currentUserId != null) {
          final optimisticMessage = Message(
            id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
            chatId: event.chatId,
            senderId: currentUserId,
            senderName: 'Saya',
            content: event.content,
            type: event.type,
            timestamp: DateTime.now(),
            status: MessageStatus.sending,
            attachmentUrl: null, // No URL yet, will use local file
            attachmentType: event.type == MessageType.image ? 'image/jpeg' : null,
          );
          
          final updatedMessages = List<Message>.from(state.messages)
            ..add(optimisticMessage);
          
          print('📸 [Hybrid] Added optimistic message with local file: ${optimisticMessage.id}');
          
          emit(state.copyWith(
            messages: updatedMessages,
          ));
        }
      }
      
      // Step 1: Send message via API (for persistence to database)
      // This ensures data is saved even if SignalR is down
      await chatRepository.sendMessage(
        event.chatId,
        event.content,
        event.type,
        attachmentFile: event.attachmentFile,
      );

      print('✅ [Hybrid] Message sent via API successfully');
      print('📡 [Hybrid] Waiting for SignalR broadcast from server...');
      print('📡 [Hybrid] UI will update automatically when message received via SignalR');
      
      // Step 2: DO NOT update UI here - let SignalR handle it
      // This prevents duplicate messages
      // Server will automatically broadcast via SignalR after saving
      // Client will receive via SignalR ReceiveMessage event
      // UI will be updated in _onMessageReceived with complete data from server
      // The optimistic message will be replaced by the real message from SignalR
      
    } catch (e) {
      print('❌ [Hybrid] Error sending message via API: $e');
      
      // Remove optimistic message if send failed
      if (event.attachmentFile != null && state.selectedChatId == event.chatId) {
        final updatedMessages = state.messages.where((m) => !m.id.startsWith('temp_')).toList();
        emit(state.copyWith(
          messages: updatedMessages,
          errorMessage: 'Gagal mengirim pesan: ${e.toString()}',
        ));
      } else {
        emit(state.copyWith(
          errorMessage: 'Gagal mengirim pesan: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _onLoadContacts(
    ChatLoadContacts event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoadingContacts: true, errorMessage: null));

    try {
      final contacts = await chatRepository.getContacts();
      emit(state.copyWith(
        isLoadingContacts: false,
        contacts: contacts,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingContacts: false,
        errorMessage: 'Gagal memuat kontak: ${e.toString()}',
      ));
    }
  }

  Future<void> _onMarkAsRead(
    ChatMarkAsRead event,
    Emitter<ChatState> emit,
  ) async {
    try {
      // Get current user ID for SignalR
      final currentUserId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      
      // Mark as read via API (for persistence)
      await chatRepository.markMessagesAsRead(event.chatId);
      
      // Also mark as read via SignalR (for realtime notification)
      if (currentUserId != null && signalRService.isConnected) {
        try {
          await signalRService.readMessage(event.chatId, currentUserId);
          print('✅ [MarkAsRead] Marked as read via SignalR');
        } catch (e) {
          print('⚠️ [MarkAsRead] SignalR readMessage failed (non-critical): $e');
          // Don't throw - API call already succeeded
        }
      }

      // Update chat unread count
      final updatedChats = state.chats.map((chat) {
        if (chat.id == event.chatId) {
          return chat.copyWith(unreadCount: 0);
        }
        return chat;
      }).toList();

      emit(state.copyWith(
        chats: updatedChats,
        filteredChats: updatedChats,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Gagal menandai pesan sebagai dibaca: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSearchMessages(
    ChatSearchMessages event,
    Emitter<ChatState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(searchResults: []));
      return;
    }

    emit(state.copyWith(isSearching: true));

    try {
      final results = await chatRepository.searchMessages(event.query);
      emit(state.copyWith(
        isSearching: false,
        searchResults: results,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSearching: false,
        errorMessage: 'Gagal mencari pesan: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSearchChats(
    ChatSearchChats event,
    Emitter<ChatState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(filteredChats: state.chats));
      return;
    }

    try {
      // Filter chats locally by name
      final filtered = state.chats
          .where((chat) =>
              chat.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(state.copyWith(filteredChats: filtered));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Gagal mencari chat: ${e.toString()}',
      ));
    }
  }

  Future<void> _onCreateChat(
    ChatCreateChat event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final newChat = await chatRepository.createChat(
        event.participantIds,
        event.name,
        event.type,
      );

      final updatedChats = List<Chat>.from(state.chats)..add(newChat);
      emit(state.copyWith(
        isLoading: false,
        chats: updatedChats,
        filteredChats: updatedChats,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal membuat chat: ${e.toString()}',
      ));
    }
  }

  void _onSelectChat(
    ChatSelectChat event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(selectedChatId: event.chatId));
  }

  void _onClearSearch(
    ChatClearSearch event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(
      searchResults: [],
      filteredChats: state.chats,
    ));
  }

  void _onClearError(
    ChatClearError event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(errorMessage: null));
  }

  Future<void> _onLoadUsers(
    ChatLoadUsers event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoadingUsers: true, errorMessage: null));

    try {
      final users = await chatRepository.getUsers(searchQuery: event.searchQuery);
      emit(state.copyWith(
        isLoadingUsers: false,
        users: users,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingUsers: false,
        errorMessage: 'Gagal memuat daftar user: ${e.toString()}',
      ));
    }
  }

  Future<void> _onCreateConversation(
ChatCreateConversation event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final conversationId = await chatRepository.createConversation(event.memberUserIds);
      
      // Get user names for the conversation
      String conversationName = 'New Conversation';
      if (event.memberUserIds.isNotEmpty) {
        // Get current user ID to exclude from name
        final currentUserId = await SecurityManager.readSecurely(AppConstants.userIdKey);
        
        // Get names of other participants (exclude current user)
        final otherUserIds = event.memberUserIds
            .where((id) => id != currentUserId)
            .toList();
        
        if (otherUserIds.isNotEmpty) {
          // Try to get names from cache first
          final names = <String>[];
          for (var userId in otherUserIds) {
            if (_userNameCache.containsKey(userId)) {
              names.add(_userNameCache[userId]!);
            } else {
              // Fetch from API if not in cache
              try {
                final users = await chatRepository.getUsers(searchQuery: userId);
                final user = users.firstWhere(
                  (u) => u.id == userId,
                  orElse: () => Contact(
                    id: userId,
                    name: 'User',
                    phoneNumber: '',
                    email: '',
                    position: '',
                    department: '',
                    isOnline: false,
                    lastSeen: null,
                    status: null,
                  ),
                );
                _userNameCache[userId] = user.name;
                names.add(user.name);
              } catch (e) {
                print('⚠️ Error fetching user name for $userId: $e');
                names.add('User');
              }
            }
          }
          
          // Set conversation name based on number of participants
          if (names.length == 1) {
            conversationName = names.first;
          } else if (names.length > 1) {
            conversationName = names.join(', ');
          }
        }
      }
      
      // Create a new chat entity from the conversation
      final newChat = Chat(
        id: conversationId,
        name: conversationName,
        type: event.memberUserIds.length == 1 ? ChatType.direct : ChatType.group,
        participantIds: event.memberUserIds,
        unreadCount: 0,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updatedChats = List<Chat>.from(state.chats)..add(newChat);
      emit(state.copyWith(
        isLoading: false,
        chats: updatedChats,
        filteredChats: updatedChats,
        selectedChatId: conversationId,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal membuat percakapan: ${e.toString()}',
      ));
    }
  }

  Future<void> _onJoinConversation(
    ChatJoinConversation event,
    Emitter<ChatState> emit,
  ) async {
    try {
      // Ensure SignalR is connected before joining
      if (!signalRService.isConnected) {
        print('🔵 SignalR not connected, connecting first...');
        await signalRService.connect();
      }
      
      await signalRService.joinConversation(
        event.conversationId,
        event.userId,
      );
      print('✅ Joined conversation via SignalR: ${event.conversationId}');
    } catch (e) {
      print('❌ Error joining conversation: $e');
      emit(state.copyWith(
        errorMessage: 'Gagal join conversation: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLeaveConversation(
    ChatLeaveConversation event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await signalRService.leaveConversation(
        event.conversationId,
        event.userId,
      );
      print('✅ Left conversation via SignalR: ${event.conversationId}');
    } catch (e) {
      print('❌ Error leaving conversation: $e');
    }
  }

  /// Handle message received via SignalR (from server broadcast)
  /// This is the source of truth for real-time message updates
  void _onMessageReceived(
    ChatMessageReceived event,
    Emitter<ChatState> emit,
  ) async {
    print('📨 [Hybrid] Message received via SignalR: ${event.message.id}');
    print('📨 [Hybrid] Message details:');
    print('   ID: ${event.message.id}');
    print('   ChatId: ${event.message.chatId}');
    print('   Content: ${event.message.content}');
    print('   SenderId: ${event.message.senderId}');
    print('   SenderName: ${event.message.senderName}');
    print('   SelectedChatId: ${state.selectedChatId}');
    
    // Validate message has required fields
    if (event.message.id.isEmpty) {
      print('⚠️ [Hybrid] Message ID is empty, skipping update');
      return;
    }
    
    if (event.message.chatId.isEmpty) {
      print('⚠️ [Hybrid] Message ChatId is empty, skipping update');
      return;
    }
    
    // Get or fetch senderName if missing (SignalR doesn't send senderName)
    Message messageWithName = event.message;
    if (event.message.senderName == 'User' || event.message.senderName.isEmpty) {
      print('🔍 [Hybrid] SenderName is missing, fetching from cache or API...');
      
      // Check cache first
      if (_userNameCache.containsKey(event.message.senderId)) {
        final cachedName = _userNameCache[event.message.senderId]!;
        print('✅ [Hybrid] Found senderName in cache: $cachedName');
        messageWithName = event.message.copyWith(senderName: cachedName);
      } else {
        // Fetch from API if not in cache
        print('📡 [Hybrid] Fetching senderName from API for senderId: ${event.message.senderId}');
        final senderName = await _getSenderName(event.message.senderId);
        if (senderName != null && senderName.isNotEmpty) {
          _userNameCache[event.message.senderId] = senderName;
          messageWithName = event.message.copyWith(senderName: senderName);
          print('✅ [Hybrid] Fetched senderName from API: $senderName');
        } else {
          print('⚠️ [Hybrid] Could not fetch senderName, using default');
        }
      }
    }
    
    // Prevent duplicate messages
    // Check if message already exists (by ID or by content + senderId + timestamp)
    // Also check for temp messages that should be replaced
    Message? existingTempMessage;
    final messageExists = state.messages.any((m) {
      // Check by ID (most reliable)
      if (m.id.isNotEmpty && messageWithName.id.isNotEmpty && m.id == messageWithName.id) {
        return true;
      }
      
      // Check if this is a temp message that should be replaced
      // Match by content + senderId + chatId + timestamp (within 10 seconds for temp messages)
      if (m.id.startsWith('temp_') && 
          m.content == messageWithName.content && 
          m.senderId == messageWithName.senderId &&
          m.chatId == messageWithName.chatId &&
          m.timestamp.difference(messageWithName.timestamp).inSeconds.abs() < 10) {
        existingTempMessage = m;
        return true;
      }
      
      // Check by content + senderId + chatId + timestamp (within 3 seconds for non-temp)
      if (m.content == messageWithName.content && 
          m.senderId == messageWithName.senderId &&
          m.chatId == messageWithName.chatId &&
          m.timestamp.difference(messageWithName.timestamp).inSeconds.abs() < 3) {
        return true;
      }
      
      return false;
    });

    if (messageExists) {
      print('⚠️ [Hybrid] Message already exists, updating instead of adding');
      // Update existing message with complete data from server
      final updatedMessages = state.messages.map((m) {
        // Match by ID first
        if (m.id.isNotEmpty && messageWithName.id.isNotEmpty && m.id == messageWithName.id) {
          print('🔄 [Hybrid] Updating message by ID: ${m.id}');
          return messageWithName.copyWith(status: MessageStatus.delivered);
        }
        
        // Match temp message - replace with real message
        if (m.id.startsWith('temp_') && existingTempMessage != null && m.id == existingTempMessage!.id) {
          print('🔄 [Hybrid] Replacing temp message ${m.id} with real message ${messageWithName.id}');
          print('   Old timestamp: ${m.timestamp}');
          print('   New timestamp: ${messageWithName.timestamp}');
          return messageWithName.copyWith(status: MessageStatus.delivered);
        }
        
        // Match by content + senderId + timestamp
        if (m.content == messageWithName.content && 
            m.senderId == messageWithName.senderId &&
            m.chatId == messageWithName.chatId &&
            m.timestamp.difference(messageWithName.timestamp).inSeconds.abs() < 3) {
          print('🔄 [Hybrid] Updating message by content match');
          return messageWithName.copyWith(status: MessageStatus.delivered);
        }
        
        return m;
      }).toList();

      // Update chat list with new last message
      final updatedChats = state.chats.map((chat) {
        if (chat.id == messageWithName.chatId) {
          return chat.copyWith(
            lastMessageId: messageWithName.id,
            lastMessageContent: messageWithName.content,
            lastMessageSenderName: messageWithName.senderName,
            lastMessageTimestamp: messageWithName.timestamp,
            updatedAt: messageWithName.timestamp,
          );
        }
        return chat;
      }).toList();

      emit(state.copyWith(
        messages: updatedMessages,
        chats: updatedChats,
        filteredChats: updatedChats,
      ));
      return;
    }

    // Add message to current messages if it's for the selected chat
    if (state.selectedChatId == messageWithName.chatId) {
      print('✅ [Hybrid] Adding new message to selected chat');
      final updatedMessages = List<Message>.from(state.messages)
        ..add(messageWithName.copyWith(status: MessageStatus.delivered));

      // Update chat list with new last message
      final updatedChats = state.chats.map((chat) {
        if (chat.id == messageWithName.chatId) {
          return chat.copyWith(
            lastMessageId: messageWithName.id,
            lastMessageContent: messageWithName.content,
            lastMessageSenderName: messageWithName.senderName,
            lastMessageTimestamp: messageWithName.timestamp,
            updatedAt: messageWithName.timestamp,
          );
        }
        return chat;
      }).toList();

      emit(state.copyWith(
        messages: updatedMessages,
        chats: updatedChats,
        filteredChats: updatedChats,
      ));
    } else {
      // Update chat list even if not selected (for unread count, last message, etc)
      print('📋 [Hybrid] Updating chat list for non-selected chat');
      final updatedChats = state.chats.map((chat) {
        if (chat.id == messageWithName.chatId) {
          return chat.copyWith(
            lastMessageId: messageWithName.id,
            lastMessageContent: messageWithName.content,
            lastMessageSenderName: messageWithName.senderName,
            lastMessageTimestamp: messageWithName.timestamp,
            updatedAt: messageWithName.timestamp,
            unreadCount: chat.unreadCount + 1, // Increment unread if not selected
          );
        }
        return chat;
      }).toList();

      emit(state.copyWith(
        chats: updatedChats,
        filteredChats: updatedChats,
      ));
    }
  }

  /// Get sender name from API based on senderId
  /// Uses cache to avoid repeated API calls
  Future<String?> _getSenderName(String senderId) async {
    try {
      // Check cache first
      if (_userNameCache.containsKey(senderId)) {
        return _userNameCache[senderId];
      }

      // Prevent multiple simultaneous requests
      if (_isLoadingUserNames) {
        print('⏳ [Hybrid] Already loading user names, waiting...');
        await Future.delayed(const Duration(milliseconds: 500));
        return _userNameCache[senderId];
      }

      _isLoadingUserNames = true;

      // Get current user ID to check if sender is current user
      final currentUserId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      if (currentUserId != null && senderId == currentUserId) {
        _userNameCache[senderId] = 'Saya';
        _isLoadingUserNames = false;
        return 'Saya';
      }

      // Fetch user list from API using repository
      final userResponse = await chatRepository.getUsers();
      
      // Build cache from user list
      for (var user in userResponse) {
        _userNameCache[user.id] = user.name;
      }

      _isLoadingUserNames = false;
      return _userNameCache[senderId];
    } catch (e) {
      print('❌ [Hybrid] Error fetching sender name: $e');
      _isLoadingUserNames = false;
      return null;
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _connectionSubscription?.cancel();
    return super.close();
  }
}
