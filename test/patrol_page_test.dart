import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardify_app/core/di/injection.dart';
import 'package:guardify_app/features/patrol/presentation/pages/home_patrol_page.dart';

void main() {
  group('Patrol Module Test', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      
      // Mock method channel for SharedPreferences
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('plugins.flutter.io/shared_preferences'),
              (MethodCall methodCall) async {
        if (methodCall.method == 'getAll') {
          return <String, dynamic>{};
        }
        return null;
      });
      
      await configureDependencies();
    });

    testWidgets('should be able to create HomePatrolPage', (WidgetTester tester) async {
      // Build the HomePatrolPage directly
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePatrolPage(),
        ),
      );

      // Just check that the page builds without error
      await tester.pump();
      
      // Verify app bar title
      expect(find.text('Patroli Hari Ini'), findsOneWidget);
    });
  });
}