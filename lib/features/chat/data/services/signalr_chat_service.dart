import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/security_manager.dart';
import '../../domain/entities/message.dart';

/// Service untuk mengelola SignalR connection untuk realtime chat
/// Menggunakan WebSocket manual karena package signalr_netcore tidak tersedia
@lazySingleton
class SignalRChatService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final _messageController = StreamController<Message>.broadcast();
  final _connectionStateController = StreamController<ConnectionState>.broadcast();
  
  bool _isConnected = false;
  String? _currentConversationId;
  String? _currentUserId;
  int _messageId = 0;
  Timer? _reconnectTimer;
  int _reconnectAttempt = 0;
  final List<Duration> _reconnectDelays = [
    const Duration(seconds: 0),
    const Duration(seconds: 2),
    const Duration(seconds: 10),
    const Duration(seconds: 30),
  ];

  /// Stream untuk menerima messages realtime
  Stream<Message> get messageStream => _messageController.stream;

  /// Stream untuk connection state changes
  Stream<ConnectionState> get connectionStateStream => _connectionStateController.stream;

  /// Status koneksi
  bool get isConnected => _isConnected && _channel != null;

  /// Initialize SignalR connection
  Future<void> initialize() async {
    try {
      final token = await SecurityManager.readSecurely(AppConstants.tokenKey);
      if (token == null || token.isEmpty) {
        throw Exception('Token not found');
      }

      // SignalR .NET Core requires negotiation first
      // Step 1: Negotiate connection to get connection ID
      final connectionId = await _negotiateConnection(token);
      
      // Step 2: Build WebSocket URL from negotiation response
      final wsUrl = _buildWebSocketUrl(connectionId);
      
      print('🔵 Connecting to SignalR WebSocket: $wsUrl');
      
      // Create WebSocket connection
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      // Listen to messages
      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
        cancelOnError: false,
      );

      _isConnected = true;
      _reconnectAttempt = 0;
      _connectionStateController.add(ConnectionState.connected);
      print('✅ SignalR service initialized and connected');
    } catch (e) {
      print('❌ Error initializing SignalR: $e');
      _isConnected = false;
      _connectionStateController.add(ConnectionState.disconnected);
      rethrow;
    }
  }

  /// Handle incoming WebSocket messages
  void _handleMessage(dynamic message) {
    try {
      if (message is String) {
        final data = jsonDecode(message);
        
        // Handle different SignalR message types
        if (data is Map<String, dynamic>) {
          // Check if it's a message
          if (data.containsKey('type')) {
            final type = data['type'] as int?;
            
            // Type 1 = Invocation (method call)
            // Type 2 = StreamItem
            // Type 3 = Completion
            // Type 4 = StreamInvocation
            // Type 5 = CancelInvocation
            // Type 6 = Ping
            // Type 7 = Close
            
            if (type == 1) {
              // Invocation - method call from server
              final target = data['target'] as String?;
              final arguments = data['arguments'] as List?;
              
              if (target == 'ReceiveMessage' && arguments != null && arguments.isNotEmpty) {
                final messageData = arguments[0] as Map<String, dynamic>;
                final message = _parseMessageFromSignalR(messageData);
                if (message != null) {
                  _messageController.add(message);
                  print('📨 Received message via SignalR: ${message.id}');
                }
              } else if (target == 'MessageSent') {
                print('✅ Message sent confirmation received');
              } else if (target == 'UserJoined') {
                print('👤 User joined conversation');
              } else if (target == 'UserLeft') {
                print('👋 User left conversation');
              }
            }
          } else if (data.containsKey('M')) {
            // Alternative format - messages array
            final messages = data['M'] as List?;
            if (messages != null) {
              for (final msg in messages) {
                if (msg is Map<String, dynamic>) {
                  final target = msg['M'] as String?;
                  final args = msg['A'] as List?;
                  
                  if (target == 'ReceiveMessage' && args != null && args.isNotEmpty) {
                    final messageData = args[0] as Map<String, dynamic>;
                    final message = _parseMessageFromSignalR(messageData);
                    if (message != null) {
                      _messageController.add(message);
                      print('📨 Received message via SignalR: ${message.id}');
                    }
                  }
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print('❌ Error handling SignalR message: $e');
    }
  }

  /// Handle WebSocket errors
  void _handleError(dynamic error) {
    print('❌ SignalR WebSocket error: $error');
    _isConnected = false;
    _connectionStateController.add(ConnectionState.disconnected);
    _scheduleReconnect();
  }

  /// Handle WebSocket disconnect
  void _handleDisconnect() {
    print('🔴 SignalR disconnected');
    _isConnected = false;
    _connectionStateController.add(ConnectionState.disconnected);
    _scheduleReconnect();
  }

  /// Schedule reconnection attempt
  void _scheduleReconnect() {
    if (_reconnectAttempt >= _reconnectDelays.length) {
      print('❌ Max reconnection attempts reached');
      return;
    }

    final delay = _reconnectDelays[_reconnectAttempt];
    _reconnectAttempt++;
    
    _connectionStateController.add(ConnectionState.reconnecting);
    print('🟡 Scheduling reconnect in ${delay.inSeconds} seconds (attempt $_reconnectAttempt)');
    
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (!_isConnected) {
        connect();
      }
    });
  }

  /// Parse message dari SignalR response
  Message? _parseMessageFromSignalR(Map<String, dynamic> data) {
    try {
      return Message(
        id: data['Id'] as String? ?? '',
        chatId: data['ConversationId'] as String? ?? '',
        senderId: data['SenderId'] as String? ?? '',
        senderName: data['SenderName'] as String? ?? 'User',
        senderProfileImageUrl: data['SenderProfileImageUrl'] as String?,
        content: data['Text'] as String? ?? '',
        type: _parseMessageType(data['Type'] as String?),
        timestamp: _parseDateTime(data['SentAt']),
        status: MessageStatus.delivered,
        attachmentUrl: _parseAttachmentUrl(data['Attachments']),
        attachmentType: _parseAttachmentType(data['Attachments']),
      );
    } catch (e) {
      print('❌ Error parsing message: $e');
      return null;
    }
  }

  /// Parse message type
  MessageType _parseMessageType(String? type) {
    if (type == null) return MessageType.text;
    switch (type.toLowerCase()) {
      case 'image':
        return MessageType.image;
      case 'file':
        return MessageType.file;
      case 'voice':
        return MessageType.voice;
      default:
        return MessageType.text;
    }
  }

  /// Parse DateTime from string
  DateTime _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return DateTime.now();
    if (dateTime is DateTime) return dateTime;
    if (dateTime is String) {
      try {
        return DateTime.parse(dateTime);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  /// Parse attachment URL
  String? _parseAttachmentUrl(dynamic attachments) {
    if (attachments == null || 
        (attachments is List && attachments.isEmpty)) {
      return null;
    }
    
    if (attachments is List && attachments.isNotEmpty) {
      final attachment = attachments[0] as Map<String, dynamic>?;
      if (attachment != null) {
        final fileName = attachment['FileName'] as String?;
        if (fileName != null && fileName.isNotEmpty) {
          final baseUrl = AppConstants.baseUrl;
          final encodedFileName = Uri.encodeComponent(fileName);
          return '$baseUrl/file/$encodedFileName';
        }
      }
    }
    
    return null;
  }

  /// Parse attachment type
  String? _parseAttachmentType(dynamic attachments) {
    if (attachments == null || 
        (attachments is List && attachments.isEmpty)) {
      return null;
    }
    
    if (attachments is List && attachments.isNotEmpty) {
      final attachment = attachments[0] as Map<String, dynamic>?;
      if (attachment != null) {
        return attachment['FileType'] as String?;
      }
    }
    
    return null;
  }

  /// Connect to SignalR hub
  Future<void> connect() async {
    if (_isConnected && _channel != null) {
      print('✅ Already connected to SignalR');
      return;
    }

    try {
      await initialize();
    } catch (e) {
      print('❌ Error connecting to SignalR: $e');
      rethrow;
    }
  }

  /// Disconnect from SignalR hub
  Future<void> disconnect() async {
    try {
      _reconnectTimer?.cancel();
      _subscription?.cancel();
      await _channel?.sink.close();
      _isConnected = false;
      _currentConversationId = null;
      _currentUserId = null;
      _connectionStateController.add(ConnectionState.disconnected);
      print('🔴 SignalR disconnected');
    } catch (e) {
      print('❌ Error disconnecting from SignalR: $e');
    }
  }

  /// Send SignalR message
  void _sendSignalRMessage(Map<String, dynamic> message) {
    if (!_isConnected || _channel == null) {
      throw Exception('Not connected to SignalR');
    }

    try {
      final jsonMessage = jsonEncode(message);
      _channel!.sink.add(jsonMessage);
    } catch (e) {
      print('❌ Error sending SignalR message: $e');
      rethrow;
    }
  }

  /// Join a conversation
  Future<void> joinConversation(String conversationId, String userId) async {
    if (!isConnected) {
      await connect();
    }

    try {
      // SignalR invocation format
      final message = {
        'type': 1, // Invocation
        'target': 'JoinConversation',
        'arguments': [conversationId, userId],
        'invocationId': '${_messageId++}',
      };
      
      _sendSignalRMessage(message);
      _currentConversationId = conversationId;
      _currentUserId = userId;
      print('✅ Joined conversation: $conversationId');
    } catch (e) {
      print('❌ Error joining conversation: $e');
      rethrow;
    }
  }

  /// Leave a conversation
  Future<void> leaveConversation(String conversationId, String userId) async {
    if (!isConnected) {
      return;
    }

    try {
      final message = {
        'type': 1, // Invocation
        'target': 'LeaveConversation',
        'arguments': [conversationId, userId],
        'invocationId': '${_messageId++}',
      };
      
      _sendSignalRMessage(message);
      if (_currentConversationId == conversationId) {
        _currentConversationId = null;
        _currentUserId = null;
      }
      print('✅ Left conversation: $conversationId');
    } catch (e) {
      print('❌ Error leaving conversation: $e');
    }
  }

  /// Send message via SignalR (optional, bisa tetap pakai API)
  Future<void> sendMessageRealtime({
    required String conversationId,
    required String senderId,
    required String text,
    List<Map<String, dynamic>>? attachments,
  }) async {
    if (!isConnected) {
      throw Exception('Not connected to SignalR');
    }

    try {
      final messageData = {
        'ConversationId': conversationId,
        'SenderId': senderId,
        'Text': text,
        if (attachments != null) 'Attachments': attachments,
      };

      final message = {
        'type': 1, // Invocation
        'target': 'SendMessage',
        'arguments': [messageData],
        'invocationId': '${_messageId++}',
      };
      
      _sendSignalRMessage(message);
      print('✅ Message sent via SignalR');
    } catch (e) {
      print('❌ Error sending message via SignalR: $e');
      rethrow;
    }
  }

  /// Negotiate SignalR connection
  /// SignalR .NET Core requires negotiation endpoint first
  Future<String> _negotiateConnection(String token) async {
    try {
      final dio = Dio();
      
      // Try different negotiation URL patterns
      // Pattern 1: /hubs/chat/negotiate (most common)
      String negotiateUrl = '${AppConstants.signalRHubUrl}/negotiate';
      
      // Alternative: if baseUrl is used, try with baseUrl
      // String negotiateUrl = '${AppConstants.baseUrl}/hubs/chat/negotiate';
      
      print('🔵 Negotiating SignalR connection: $negotiateUrl');
      
      final response = await dio.post(
        negotiateUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            // Don't throw on 404, we'll handle it
            return status! < 500;
          },
        ),
        data: {},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final connectionId = data['connectionId'] as String?;
        final availableTransports = data['availableTransports'] as List?;
        
        print('✅ SignalR negotiation successful. ConnectionId: $connectionId');
        print('📡 Available transports: $availableTransports');
        
        // Return connection ID for WebSocket URL
        if (connectionId == null || connectionId.isEmpty) {
          throw Exception('ConnectionId is null or empty');
        }
        return connectionId;
      } else if (response.statusCode == 404) {
        // Try alternative negotiation URL
        print('⚠️ Negotiation endpoint not found at $negotiateUrl, trying alternative...');
        
        // Try with baseUrl
        final altNegotiateUrl = '${AppConstants.baseUrl}/hubs/chat/negotiate';
        print('🔵 Trying alternative negotiation URL: $altNegotiateUrl');
        
        final altResponse = await dio.post(
          altNegotiateUrl,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
          data: {},
        );
        
        if (altResponse.statusCode == 200) {
          final data = altResponse.data;
          final connectionId = data['connectionId'] as String?;
          final availableTransports = data['availableTransports'] as List?;
          
          print('✅ SignalR negotiation successful (alternative). ConnectionId: $connectionId');
          print('📡 Available transports: $availableTransports');
          
          if (connectionId == null || connectionId.isEmpty) {
            throw Exception('ConnectionId is null or empty');
          }
          return connectionId;
        } else {
          throw Exception('Negotiation failed with status ${altResponse.statusCode}. '
              'Tried: $negotiateUrl and $altNegotiateUrl');
        }
      } else {
        throw Exception('Negotiation failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error negotiating SignalR connection: $e');
      rethrow;
    }
  }

  /// Build WebSocket URL from negotiation response
  String _buildWebSocketUrl(String connectionId) {
    // Build WebSocket URL
    // SignalR .NET Core WebSocket URL format:
    // ws://host/hubs/chat?id=<connectionId>
    // or wss://host/hubs/chat?id=<connectionId>
    
    final baseUrl = AppConstants.signalRHubUrl;
    String wsProtocol;
    String wsHost;
    
    if (baseUrl.startsWith('https://')) {
      wsProtocol = 'wss://';
      wsHost = baseUrl.substring(8); // Remove 'https://'
    } else if (baseUrl.startsWith('http://')) {
      wsProtocol = 'ws://';
      wsHost = baseUrl.substring(7); // Remove 'http://'
    } else {
      wsProtocol = 'ws://';
      wsHost = baseUrl;
    }
    
    // Remove port if it's :0 or default port
    if (wsHost.contains(':0/')) {
      wsHost = wsHost.replaceAll(':0/', '/');
    }
    if (wsHost.endsWith(':0')) {
      wsHost = wsHost.replaceAll(':0', '');
    }
    
    // Build WebSocket URL with connection ID
    final wsUrl = '$wsProtocol$wsHost?id=$connectionId';
    
    return wsUrl;
  }

  /// Dispose resources
  void dispose() {
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _messageController.close();
    _connectionStateController.close();
    disconnect();
    _channel = null;
  }
}

/// Connection state enum
enum ConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
}
