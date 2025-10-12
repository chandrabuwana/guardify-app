import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../../../core/design/colors.dart';

class ChatConversationPage extends StatefulWidget {
  final Chat chat;

  const ChatConversationPage({
    super.key,
    required this.chat,
  });

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(ChatLoadMessages(widget.chat.id));
    context.read<ChatBloc>().add(ChatMarkAsRead(widget.chat.id));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutral10,
      appBar: _buildAppBar(),
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

          // Auto scroll to bottom when new message is added
          if (state.messages.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Messages List
              Expanded(
                child: state.isLoadingMessages
                    ? const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      )
                    : state.messages.isEmpty
                        ? _buildEmptyMessages()
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.all(16.w),
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              final message = state.messages[index];
                              final isLastMessage =
                                  index == state.messages.length - 1;
                              final showDateSeparator = index == 0 ||
                                  !_isSameDay(
                                    state.messages[index - 1].timestamp,
                                    message.timestamp,
                                  );

                              return Column(
                                children: [
                                  if (showDateSeparator)
                                    _buildDateSeparator(message.timestamp),
                                  _buildMessageBubble(message, isLastMessage),
                                ],
                              );
                            },
                          ),
              ),

              // Message Input
              _buildMessageInput(),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            backgroundImage: widget.chat.profileImageUrl != null
                ? NetworkImage(widget.chat.profileImageUrl!)
                : null,
            child: widget.chat.profileImageUrl == null
                ? Icon(
                    widget.chat.type == ChatType.group
                        ? Icons.group
                        : Icons.person,
                    color: Colors.white,
                    size: 20.sp,
                  )
                : null,
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chat.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.chat.type == ChatType.group
                      ? 'Grup'
                      : 'Aktif 18 menit yang lalu',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {
            // Show more options
          },
        ),
      ],
    );
  }

  Widget _buildEmptyMessages() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64.sp,
            color: neutral50,
          ),
          16.verticalSpace,
          Text(
            'Belum ada pesan',
            style: TextStyle(
              fontSize: 16.sp,
              color: neutral70,
            ),
          ),
          8.verticalSpace,
          Text(
            'Mulai percakapan dengan mengirim pesan',
            style: TextStyle(
              fontSize: 14.sp,
              color: neutral50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(DateTime timestamp) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Text(
        DateFormat('dd/MM/yyyy').format(timestamp),
        style: TextStyle(
          fontSize: 12.sp,
          color: neutral50,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isLastMessage) {
    final isMe = message.senderId == 'current_user';

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16.r,
              backgroundColor: primary10,
              backgroundImage: message.senderProfileImageUrl != null
                  ? NetworkImage(message.senderProfileImageUrl!)
                  : null,
              child: message.senderProfileImageUrl == null
                  ? Icon(
                      Icons.person,
                      color: primaryColor,
                      size: 16.sp,
                    )
                  : null,
            ),
            8.horizontalSpace,
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: isMe ? primaryColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(isMe ? 16.r : 4.r),
                  bottomRight: Radius.circular(isMe ? 4.r : 16.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMe)
                    Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  if (!isMe) 4.verticalSpace,
                  Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isMe ? Colors.white : neutral90,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isMe
                          ? Colors.white.withValues(alpha: 0.7)
                          : neutral50,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            8.horizontalSpace,
            CircleAvatar(
              radius: 16.r,
              backgroundColor: primary10,
              child: Icon(
                Icons.person,
                color: primaryColor,
                size: 16.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Attachment Button
          IconButton(
            icon: Icon(
              Icons.attach_file,
              color: neutral50,
              size: 24.sp,
            ),
            onPressed: () {
              // Handle attachment
            },
          ),

          // Camera Button
          IconButton(
            icon: Icon(
              Icons.camera_alt,
              color: neutral50,
              size: 24.sp,
            ),
            onPressed: () {
              // Handle camera
            },
          ),

          // Message Input Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: neutral10,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Ketik pesan disini',
                  hintStyle: TextStyle(
                    color: neutral50,
                    fontSize: 14.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),

          // Send Button
          IconButton(
            icon: Icon(
              Icons.mic,
              color: neutral50,
              size: 24.sp,
            ),
            onPressed: () {
              // Handle voice message
            },
          ),

          // Send Button
          IconButton(
            icon: Icon(
              Icons.send,
              color: primaryColor,
              size: 24.sp,
            ),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      context.read<ChatBloc>().add(
            ChatSendMessage(
              chatId: widget.chat.id,
              content: content,
              type: MessageType.text,
            ),
          );
      _messageController.clear();
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
