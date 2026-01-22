import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/security_manager.dart';

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
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  String? _currentUserId;
  final Map<String, Uint8List?> _imageCache = {}; // Cache untuk image bytes

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
    context.read<ChatBloc>().add(ChatLoadMessages(widget.chat.id));
    context.read<ChatBloc>().add(ChatMarkAsRead(widget.chat.id));
    
    // Join conversation via SignalR after loading user ID
    _loadCurrentUserId().then((_) {
      if (_currentUserId != null) {
        context.read<ChatBloc>().add(
              ChatJoinConversation(
                conversationId: widget.chat.id,
                userId: _currentUserId!,
              ),
            );
      }
    });
  }

  Future<void> _loadCurrentUserId() async {
    final userId = await SecurityManager.readSecurely(AppConstants.userIdKey);
    setState(() {
      _currentUserId = userId;
    });
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
    final isMe = _currentUserId != null && message.senderId == _currentUserId;

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
                  
                  // Show attachment image if available
                  if (message.attachmentUrl != null && 
                      message.type == MessageType.image)
                    Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      constraints: BoxConstraints(
                        maxWidth: 200.w,
                        maxHeight: 200.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isMe 
                              ? Colors.white.withValues(alpha: 0.3)
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: _buildImageWidget(message.attachmentUrl!),
                      ),
                    ),
                  
                  // Show text content if available
                  if (message.content.isNotEmpty)
                    Text(
                      message.content,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isMe ? Colors.white : neutral90,
                      ),
                    ),
                  
                  // Show file attachment info if not image
                  if (message.attachmentUrl != null && 
                      message.type != MessageType.image)
                    Container(
                      padding: EdgeInsets.all(8.w),
                      margin: EdgeInsets.only(bottom: 4.h),
                      decoration: BoxDecoration(
                        color: isMe 
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.attach_file,
                            size: 16.sp,
                            color: isMe ? Colors.white : neutral70,
                          ),
                          8.horizontalSpace,
                          Expanded(
                            child: Text(
                              message.attachmentUrl!.split('/').last,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isMe ? Colors.white : neutral70,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selected Image Preview
          if (_selectedImage != null)
            Container(
              margin: EdgeInsets.only(bottom: 8.h),
              height: 100.h,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.file(
                      _selectedImage!,
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          // Input Row
          Row(
            children: [
              // Attachment Button (Gallery)
              IconButton(
                icon: Icon(
                  Icons.attach_file,
                  color: neutral50,
                  size: 24.sp,
                ),
                onPressed: _pickImageFromGallery,
              ),

              // Camera Button
              IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  color: neutral50,
                  size: 24.sp,
                ),
                onPressed: _pickImageFromCamera,
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
                  Icons.send,
                  color: primaryColor,
                  size: 24.sp,
                ),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih gambar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission != PermissionStatus.granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Akses kamera ditolak'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty || _selectedImage != null) {
      context.read<ChatBloc>().add(
            ChatSendMessage(
              chatId: widget.chat.id,
              content: content,
              type: MessageType.text,
              attachmentFile: _selectedImage,
            ),
          );
      _messageController.clear();
      setState(() {
        _selectedImage = null;
      });
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Build image widget - use direct Image.network for S3 URLs, auth header for API URLs
  Widget _buildImageWidget(String imageUrl) {
    // Check if it's an S3 URL (public, no auth needed)
    final isS3Url = imageUrl.contains('s3.ap-southeast-1.amazonaws.com') ||
                    imageUrl.contains('s3.amazonaws.com');
    
    if (isS3Url) {
      // S3 URL - use Image.network directly (public access)
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: 200.w,
        height: 200.h,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 200.w,
            height: 200.h,
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                color: primaryColor,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 200.w,
            height: 200.h,
            color: Colors.grey.shade200,
            child: Icon(
              Icons.broken_image,
              color: Colors.grey,
              size: 48.sp,
            ),
          );
        },
      );
    }
    
    // API URL - use authorization header
    return _buildNetworkImageWithAuth(imageUrl);
  }

  /// Build network image with authorization header
  Widget _buildNetworkImageWithAuth(String imageUrl) {
    // Check cache first
    if (_imageCache.containsKey(imageUrl) && _imageCache[imageUrl] != null) {
      return Image.memory(
        _imageCache[imageUrl]!,
        fit: BoxFit.cover,
        width: 200.w,
        height: 200.h,
      );
    }

    // Load image with authorization
    return FutureBuilder<Uint8List?>(
      future: _loadImageWithAuth(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 200.w,
            height: 200.h,
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Container(
            width: 200.w,
            height: 200.h,
            color: Colors.grey.shade200,
            child: Icon(
              Icons.broken_image,
              color: Colors.grey,
              size: 48.sp,
            ),
          );
        }

        // Cache the image
        _imageCache[imageUrl] = snapshot.data;

        return Image.memory(
          snapshot.data!,
          fit: BoxFit.cover,
          width: 200.w,
          height: 200.h,
        );
      },
    );
  }

  /// Load image with authorization header using Dio
  Future<Uint8List?> _loadImageWithAuth(String imageUrl) async {
    try {
      final token = await SecurityManager.readSecurely(AppConstants.tokenKey);
      
      final dio = Dio();
      final response = await dio.get<Uint8List>(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data;
    } catch (e) {
      debugPrint('Error loading image: $e');
      return null;
    }
  }
}
