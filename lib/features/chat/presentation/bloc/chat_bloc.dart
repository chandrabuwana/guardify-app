import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc(this.chatRepository) : super(ChatState.initial()) {
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
      final results = await chatRepository.searchChats(event.query);
      emit(state.copyWith(filteredChats: results));
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
}
