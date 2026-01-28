import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import '../../core/navigation/app_navigator_key.dart';
import '../../shared/widgets/panic_button_popup.dart';
import '../../features/panic_button/data/models/panic_button_notification_model.dart';

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'guardify_default',
    'Guardify Notifications',
    description: 'Default notifications channel',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    final initializationSettings = InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/launcher_icon'),
      iOS: const DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(initializationSettings);

    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidPlugin?.createNotificationChannel(_androidChannel);

      await androidPlugin?.requestNotificationsPermission();
    }

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    // Check if this is a panic button notification
    final type = message.data['type']?.toString();
    
    if (type == 'panic_button') {
      // Show panic button popup with vibration
      _showPanicButtonPopup(message.data);
      return;
    }

    // Handle regular notification
    await _showForegroundNotification(message);
  }

  void _showPanicButtonPopup(Map<String, dynamic> data) {
    final navigatorKey = AppNavigatorKey.navigatorKey;
    final context = navigatorKey.currentContext;
    
    if (context == null) {
      print('⚠️ [PushNotification] Cannot show panic popup: No context available');
      return;
    }

    // Extract data field (the actual panic button data)
    Map<String, dynamic> panicButtonData;
    if (data.containsKey('data') && data['data'] is Map) {
      panicButtonData = Map<String, dynamic>.from(data['data'] as Map);
    } else {
      // If data is not nested, use all data except 'type'
      panicButtonData = Map<String, dynamic>.from(data);
      panicButtonData.remove('type');
    }

    // Try to parse as PanicButtonNotificationModel
    PanicButtonNotificationModel? notificationModel;
    if (panicButtonData.isNotEmpty) {
      try {
        notificationModel = PanicButtonNotificationModel.fromJson(panicButtonData);
        print('✅ [PushNotification] Successfully parsed panic button notification');
      } catch (e) {
        print('⚠️ [PushNotification] Failed to parse panic button data: $e');
        print('⚠️ [PushNotification] Raw data: $panicButtonData');
        // Continue with raw data if parsing fails
        notificationModel = null;
      }
    }

    // Show popup that cannot be closed
    showDialog(
      context: context,
      barrierDismissible: false, // Cannot dismiss by tapping outside
      builder: (dialogContext) => PanicButtonPopup(
        panicButtonData: notificationModel,
        rawData: panicButtonData,
        durationSeconds: 45, // 45 seconds (between 30-60)
      ),
    );
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;

    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();

    if (title == null && body == null) {
      return;
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}
