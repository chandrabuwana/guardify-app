import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
}

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel? _androidChannel;
  RemoteMessage? _initialMessage;
  GlobalKey<NavigatorState>? _navigatorKey;

  Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    _navigatorKey = navigatorKey;
    await _requestPermissions();
    await _configureForegroundPresentation();
    await _initLocalNotifications();

    _initialMessage = await _messaging.getInitialMessage();

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _navigateFromNotification(message);
    });

    if (_initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_initialMessage != null) {
          _navigateFromNotification(_initialMessage!);
          _initialMessage = null;
        }
      });
    }
  }

  Future<String?> getToken() => _messaging.getToken();

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    if (Platform.isAndroid) {
      await Permission.notification.request();
    }
  }

  Future<void> _configureForegroundPresentation() async {
    if (Platform.isIOS) {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        _navigateToChatList();
      },
    );

    if (Platform.isAndroid) {
      _androidChannel = const AndroidNotificationChannel(
        'chat_messages',
        'Chat Messages',
        description: 'Notifications for incoming chat messages',
        importance: Importance.high,
      );

      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidPlugin?.createNotificationChannel(_androidChannel!);
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;

    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();

    if (title == null && body == null) {
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      _androidChannel?.id ?? 'chat_messages',
      _androidChannel?.name ?? 'Chat Messages',
      channelDescription:
          _androidChannel?.description ?? 'Notifications for incoming chat messages',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: message.data['chatId']?.toString(),
    );
  }

  void _navigateFromNotification(RemoteMessage message) {
    _navigateToChatList();
  }

  void _navigateToChatList() {
    final navigator = _navigatorKey?.currentState;
    if (navigator == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToChatList();
      });
      return;
    }

    navigator.pushNamed('/chat');
  }
}
