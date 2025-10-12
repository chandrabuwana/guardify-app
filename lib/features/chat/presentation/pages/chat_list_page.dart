import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../../domain/entities/chat.dart';
import '../../../../core/design/colors.dart';
import 'chat_conversation_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(const ChatLoadChats());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutral10,
      appBar: AppBar(
        title: const Text(
          'Pesan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: errorColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          return Column(
            children: [
              // Search Bar
              Container(
                padding: EdgeInsets.all(16.w),
                color: Colors.white,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Q Cari',
                    hintStyle: TextStyle(
                      color: neutral50,
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: neutral50,
                      size: 20.sp,
                    ),
                    filled: true,
                    fillColor: neutral10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                  onChanged: (value) {
                    context.read<ChatBloc>().add(ChatSearchChats(value));
                  },
                ),
              ),

              // Chat List
              Expanded(
                child: state.filteredChats.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: state.filteredChats.length,
                        itemBuilder: (context, index) {
                          final chat = state.filteredChats[index];
                          return _buildChatItem(chat);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Empty state illustration
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: neutral30,
              borderRadius: BorderRadius.circular(60.r),
            ),
            child: Icon(
              Icons.mail_outline,
              size: 60.sp,
              color: neutral50,
            ),
          ),
          24.verticalSpace,
          Text(
            'Belum ada pesan',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: neutral70,
            ),
          ),
          8.verticalSpace,
          Text(
            'Mulai percakapan dengan rekan kerja Anda',
            style: TextStyle(
              fontSize: 14.sp,
              color: neutral50,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(Chat chat) {
    return Container(
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Get ChatBloc before creating new route context
            final chatBloc = context.read<ChatBloc>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: chatBloc,
                  child: ChatConversationPage(chat: chat),
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: primary10,
                  backgroundImage: chat.profileImageUrl != null
                      ? NetworkImage(chat.profileImageUrl!)
                      : null,
                  child: chat.profileImageUrl == null
                      ? Icon(
                          chat.type == ChatType.group
                              ? Icons.group
                              : Icons.person,
                          color: primaryColor,
                          size: 24.sp,
                        )
                      : null,
                ),
                12.horizontalSpace,

                // Chat Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chat.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: neutral90,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chat.lastMessageTimestamp != null)
                            Text(
                              _formatTime(chat.lastMessageTimestamp!),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: neutral50,
                              ),
                            ),
                        ],
                      ),
                      4.verticalSpace,

                      // Last Message
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.lastMessageContent ?? 'Tidak ada pesan',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: neutral70,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          if (chat.unreadCount > 0) ...[
                            8.horizontalSpace,
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                chat.unreadCount.toString(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    } else if (difference.inHours > 0) {
      return DateFormat('HH:mm').format(timestamp);
    } else {
      return DateFormat('HH:mm').format(timestamp);
    }
  }
}
