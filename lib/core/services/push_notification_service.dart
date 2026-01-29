import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import '../../core/navigation/app_navigator_key.dart';
import '../../shared/widgets/panic_button_popup.dart';
import '../../features/panic_button/data/models/panic_button_mobile_response_model.dart';

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
    print('🚨 [PushNotification] Showing panic button popup...');
    final navigatorKey = AppNavigatorKey.navigatorKey;
    final context = navigatorKey.currentContext;
    
    if (context == null) {
      print('⚠️ [PushNotification] Cannot show panic popup: No context available');
      return;
    }
    
    print('✅ [PushNotification] Context available, proceeding to show popup');

    // Extract data field (the actual panic button data)
    Map<String, dynamic> panicButtonData;
    
    print('🔍 [PushNotification] Received data keys: ${data.keys.toList()}');
    print('🔍 [PushNotification] Data content: $data');
    
    if (data.containsKey('data')) {
      final dataField = data['data'];
      print('🔍 [PushNotification] Data field type: ${dataField.runtimeType}');
      print('🔍 [PushNotification] Data field content: $dataField');
      
      if (dataField is Map) {
        // Data is already a Map
        panicButtonData = Map<String, dynamic>.from(dataField);
        print('✅ [PushNotification] Data is Map, extracted: $panicButtonData');
      } else if (dataField is String) {
        // Data is a JSON string, need to parse it
        try {
          print('🔍 [PushNotification] Data is String, attempting to parse JSON...');
          panicButtonData = jsonDecode(dataField) as Map<String, dynamic>;
          print('✅ [PushNotification] Successfully parsed JSON string: $panicButtonData');
        } catch (e) {
          print('⚠️ [PushNotification] Failed to parse JSON string: $e');
          // Fallback: use all data except 'type'
          panicButtonData = Map<String, dynamic>.from(data);
          panicButtonData.remove('type');
        }
      } else {
        // Unknown type, use all data except 'type'
        print('⚠️ [PushNotification] Data field is unknown type, using all data');
        panicButtonData = Map<String, dynamic>.from(data);
        panicButtonData.remove('type');
      }
    } else {
      // If data is not nested, use all data except 'type'
      print('⚠️ [PushNotification] No "data" field found, using all data except "type"');
      panicButtonData = Map<String, dynamic>.from(data);
      panicButtonData.remove('type');
    }

    print('🔍 [PushNotification] Final panicButtonData keys: ${panicButtonData.keys.toList()}');
    print('🔍 [PushNotification] Final panicButtonData: $panicButtonData');

    // Try to parse as PanicButtonMobileResponseModel (new simplified model)
    PanicButtonMobileResponseModel? mobileResponseModel;
    if (panicButtonData.isNotEmpty) {
      try {
        mobileResponseModel = PanicButtonMobileResponseModel.fromJson(panicButtonData);
        print('✅ [PushNotification] Successfully parsed panic button mobile response');
        print('✅ [PushNotification] Parsed model - Reporter: ${mobileResponseModel.reporter ?? "null"}');
        print('✅ [PushNotification] Parsed model - AreasName: ${mobileResponseModel.areasName ?? "null"}');
        print('✅ [PushNotification] Parsed model - IncidentName: ${mobileResponseModel.incidentName ?? "null"}');
        print('✅ [PushNotification] Parsed model - Description: ${mobileResponseModel.description ?? "null"}');
        print('✅ [PushNotification] Parsed model - Status: ${mobileResponseModel.status ?? "null"}');
        print('✅ [PushNotification] Parsed model - ReporterDate: ${mobileResponseModel.reporterDate ?? "null"}');
      } catch (e, stackTrace) {
        print('⚠️ [PushNotification] Failed to parse panic button mobile response: $e');
        print('⚠️ [PushNotification] Stack trace: $stackTrace');
        print('⚠️ [PushNotification] Raw data: $panicButtonData');
        // Continue with raw data if parsing fails
        mobileResponseModel = null;
      }
    } else {
      print('⚠️ [PushNotification] panicButtonData is empty!');
    }

    // Show popup that cannot be closed
    print('🚨 [PushNotification] Displaying panic button popup dialog...');
    showDialog(
      context: context,
      barrierDismissible: false, // Cannot dismiss by tapping outside
      builder: (dialogContext) {
        print('✅ [PushNotification] Panic button popup dialog created');
        return PanicButtonPopup(
          mobileResponseData: mobileResponseModel,
          rawData: panicButtonData,
          durationSeconds: 45, // 45 seconds (between 30-60)
        );
      },
    );
    print('✅ [PushNotification] Panic button popup dialog shown');
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
