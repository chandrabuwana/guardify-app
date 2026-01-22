import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../data/services/signalr_chat_service.dart';
import 'chat_event.dart';
import 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final SignalRChatService signalRService;
  StreamSubscription<Message>? _messageSubscription;
  StreamSubscription<ConnectionState>? _connectionSubscription;

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
    on<ChatLoadUsers>(_onLoadUsers);
    on<ChatCreateConversation>(_onCreateConversation);
    on<ChatJoinConversation>(_onJoinConversation);
    on<ChatLeaveConversation>(_onLeaveConversation);
    on<ChatMessageReceived>(_onMessageReceived);

    // Setup SignalR listeners
    _setupSignalRListeners();
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

  Future<void> _onLoadMessages(
    ChatLoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoadingMessages: true, errorMessage: null));

    try {
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

  Future<void> _onSendMessage(
    ChatSendMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final newMessage = await chatRepository.sendMessage(
        event.chatId,
        event.content,
        event.type,
        attachmentFile: event.attachmentFile,
      );

      // Add message to current messages
      final updatedMessages = List<Message>.from(state.messages)
        ..add(newMessage);

      // Update chat list with new last message
      final updatedChats = state.chats.map((chat) {
        if (chat.id == event.chatId) {
          return chat.copyWith(
            lastMessageId: newMessage.id,
            lastMessageContent: newMessage.content,
            lastMessageSenderName: newMessage.senderName,
            lastMessageTimestamp: newMessage.timestamp,
            updatedAt: newMessage.timestamp,
          );
        }
        return chat;
      }).toList();

      emit(state.copyWith(
        messages: updatedMessages,
        chats: updatedChats,
        filteredChats: updatedChats,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Gagal mengirim pesan: ${e.toString()}',
      ));
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
      await chatRepository.markMessagesAsRead(event.chatId);

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
      
      // Create a new chat entity from the conversation
      // Note: You might need to fetch full chat details from API
      final newChat = Chat(
        id: conversationId,
        name: 'New Conversation', // Will be updated when chat details are loaded
        type: ChatType.direct,
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

  void _onMessageReceived(
    ChatMessageReceived event,
    Emitter<ChatState> emit,
  ) {
    // Add message to current messages if it's for the selected chat
    if (state.selectedChatId == event.message.chatId) {
      final updatedMessages = List<Message>.from(state.messages)
        ..add(event.message);

      // Update chat list with new last message
      final updatedChats = state.chats.map((chat) {
        if (chat.id == event.message.chatId) {
          return chat.copyWith(
            lastMessageId: event.message.id,
            lastMessageContent: event.message.content,
            lastMessageSenderName: event.message.senderName,
            lastMessageTimestamp: event.message.timestamp,
            updatedAt: event.message.timestamp,
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
      // Update chat list even if not selected
      final updatedChats = state.chats.map((chat) {
        if (chat.id == event.message.chatId) {
          return chat.copyWith(
            lastMessageId: event.message.id,
            lastMessageContent: event.message.content,
            lastMessageSenderName: event.message.senderName,
            lastMessageTimestamp: event.message.timestamp,
            updatedAt: event.message.timestamp,
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

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _connectionSubscription?.cancel();
    return super.close();
  }
}
