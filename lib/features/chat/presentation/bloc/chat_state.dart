import 'package:equatable/equatable.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/contact.dart';

class ChatState extends Equatable {
  final List<Chat> chats;
  final List<Chat> filteredChats;
  final List<Message> messages;
  final List<Contact> contacts;
  final List<Contact> users; // Users from API for chat
  final List<Message> searchResults;
  final String? selectedChatId;
  final bool isLoading;
  final bool isLoadingMessages;
  final bool isLoadingContacts;
  final bool isLoadingUsers;
  final bool isSearching;
  final String? errorMessage;

  const ChatState({
    required this.chats,
    required this.filteredChats,
    required this.messages,
    required this.contacts,
    required this.users,
    required this.searchResults,
    this.selectedChatId,
    required this.isLoading,
    required this.isLoadingMessages,
    required this.isLoadingContacts,
    required this.isLoadingUsers,
    required this.isSearching,
    this.errorMessage,
  });

  factory ChatState.initial() {
    return const ChatState(
      chats: [],
      filteredChats: [],
      messages: [],
      contacts: [],
      users: [],
      searchResults: [],
      isLoading: false,
      isLoadingMessages: false,
      isLoadingContacts: false,
      isLoadingUsers: false,
      isSearching: false,
    );
  }

  ChatState copyWith({
    List<Chat>? chats,
    List<Chat>? filteredChats,
    List<Message>? messages,
    List<Contact>? contacts,
    List<Contact>? users,
    List<Message>? searchResults,
    String? selectedChatId,
    bool? isLoading,
    bool? isLoadingMessages,
    bool? isLoadingContacts,
    bool? isLoadingUsers,
    bool? isSearching,
    String? errorMessage,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      filteredChats: filteredChats ?? this.filteredChats,
      messages: messages ?? this.messages,
      contacts: contacts ?? this.contacts,
      users: users ?? this.users,
      searchResults: searchResults ?? this.searchResults,
      selectedChatId: selectedChatId ?? this.selectedChatId,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isLoadingContacts: isLoadingContacts ?? this.isLoadingContacts,
      isLoadingUsers: isLoadingUsers ?? this.isLoadingUsers,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        chats,
        filteredChats,
        messages,
        contacts,
        users,
        searchResults,
        selectedChatId,
        isLoading,
        isLoadingMessages,
        isLoadingContacts,
        isLoadingUsers,
        isSearching,
        errorMessage,
      ];
}
