import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardify_app/core/di/injection.dart';
import 'package:guardify_app/features/home/presentation/pages/home_page.dart';

void main() {
  group('Home to Patrol Navigation Test', () {
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

    testWidgets('should display patrol menu item', (WidgetTester tester) async {
      // Build the HomePage
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
        ),
      );

      // Wait for the page to load
      await tester.pumpAndSettle();

      // Look for the patrol menu item
      expect(find.text('Patroli Security'), findsOneWidget);
    });
  });
}