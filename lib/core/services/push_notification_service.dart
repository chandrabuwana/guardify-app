import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
    playSound: true,
    enableVibration: true,
  );

  // Special channel for panic button with maximum priority
  static const AndroidNotificationChannel _panicButtonChannel =
      AndroidNotificationChannel(
    'guardify_panic_button',
    'Panic Button Alerts',
    description: 'Critical emergency notifications',
    importance: Importance.max, // Maximum importance for heads-up notification
    playSound: true,
    enableVibration: true,
    enableLights: true,
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
      
      // Create panic button channel with maximum priority
      await androidPlugin?.createNotificationChannel(_panicButtonChannel);

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
    
    // Handle notification when app is opened from background/terminated state
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    // Check if app was opened from a terminated state via notification
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('🚨 [PushNotification] App opened from terminated state via notification');
      // Delay to ensure app is fully initialized
      Future.delayed(const Duration(milliseconds: 1000), () {
        _handleMessageOpenedApp(initialMessage);
      });
    }
  }
  
  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    print('🚨 [PushNotification] Message opened app - data: ${message.data}');
    
    // Check if this is a panic button notification
    final type = message.data['type']?.toString();
    
    if (type == 'panic_button') {
      print('🚨 [PushNotification] Panic button notification opened app');
      // Wait a bit for app to be fully ready
      await Future.delayed(const Duration(milliseconds: 500));
      _showPanicButtonPopup(message.data);
      return;
    }
    
    // Handle other notification types if needed
    print('ℹ️ [PushNotification] Regular notification opened app');
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
    
    // Wait for context to be available (especially when app is opened from terminated state)
    _waitForContextAndShow(data);
  }
  
  void _waitForContextAndShow(Map<String, dynamic> data, {int retryCount = 0}) {
    final navigatorKey = AppNavigatorKey.navigatorKey;
    final context = navigatorKey.currentContext;
    
    if (context == null) {
      if (retryCount < 10) {
        // Retry up to 10 times (5 seconds total)
        print('⚠️ [PushNotification] Context not available, retrying... (${retryCount + 1}/10)');
        Future.delayed(const Duration(milliseconds: 500), () {
          _waitForContextAndShow(data, retryCount: retryCount + 1);
        });
        return;
      } else {
        print('❌ [PushNotification] Cannot show panic popup: No context available after retries');
        return;
      }
    }
    
    print('✅ [PushNotification] Context available, proceeding to show popup');
    
    // Extract and parse data
    _processAndShowPopup(data, context);
  }
  
  void _processAndShowPopup(Map<String, dynamic> data, BuildContext context) {

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
    
    // Use rootNavigator to ensure dialog shows even when app is opened from terminated state
    showDialog(
      context: context,
      barrierDismissible: false, // Cannot dismiss by tapping outside
      useRootNavigator: true, // Important: use root navigator
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
        playSound: true,
        enableVibration: true,
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

  /// Show high-priority panic button notification (for background/terminated state)
  /// This creates a heads-up notification that appears on screen immediately
  Future<void> showPanicButtonNotification(RemoteMessage message) async {
    print('🚨 [PushNotification] Showing panic button heads-up notification...');
    
    final notification = message.notification;
    final title = notification?.title ?? 'PANIC BUTTON AKTIF';
    final body = notification?.body ?? 'Ada situasi darurat yang memerlukan perhatian segera!';
    
    // Extract panic button data for notification body
    String notificationBody = body;
    try {
      final data = message.data;
      Map<String, dynamic> panicButtonData;
      
      if (data.containsKey('data') && data['data'] is Map) {
        panicButtonData = Map<String, dynamic>.from(data['data'] as Map);
      } else {
        panicButtonData = Map<String, dynamic>.from(data);
        panicButtonData.remove('type');
      }
      
      // Build detailed notification body
      final reporter = panicButtonData['Reporter']?.toString() ?? '';
      final area = panicButtonData['AreasName']?.toString() ?? '';
      final incident = panicButtonData['IncidentName']?.toString() ?? '';
      
      if (reporter.isNotEmpty || area.isNotEmpty || incident.isNotEmpty) {
        final details = <String>[];
        if (reporter.isNotEmpty) details.add('Pelapor: $reporter');
        if (area.isNotEmpty) details.add('Area: $area');
        if (incident.isNotEmpty) details.add('Jenis: $incident');
        notificationBody = '${body}\n\n${details.join('\n')}';
      }
    } catch (e) {
      print('⚠️ [PushNotification] Error building notification body: $e');
    }
    
    // Create notification with maximum priority for heads-up display
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _panicButtonChannel.id,
        _panicButtonChannel.name,
        channelDescription: _panicButtonChannel.description,
        importance: Importance.max, // Maximum importance
        priority: Priority.max, // Maximum priority
        playSound: true,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([
          0, 500, 200, 500, 200, 500, 200, 500, 200, 500, // Strong vibration pattern
        ]),
        enableLights: true,
        color: const Color(0xFFE74C3C), // Red color for urgency
        icon: '@mipmap/launcher_icon',
        styleInformation: BigTextStyleInformation(
          notificationBody,
          contentTitle: title,
          summaryText: 'Tekan untuk membuka aplikasi',
        ),
        // Full screen intent for maximum visibility (requires user permission)
        fullScreenIntent: false, // Set to true if you want full screen (requires special permission)
        category: AndroidNotificationCategory.alarm, // Alarm category for high priority
        ongoing: true, // Make it ongoing so it's harder to dismiss
        autoCancel: false, // Don't auto-cancel, user must interact
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        interruptionLevel: InterruptionLevel.critical, // Critical for iOS
      ),
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      notificationBody,
      details,
    );
    
    print('✅ [PushNotification] Panic button heads-up notification shown');
  }
}
