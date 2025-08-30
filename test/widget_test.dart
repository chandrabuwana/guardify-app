// Guardify Security App - Widget Tests
//
// This file contains widget tests for the Guardify Security App.

import 'package:flutter_test/flutter_test.dart';
import 'package:guardify_app/main_simple.dart';

void main() {
  testWidgets('Guardify app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GuardifyApp());

    // Verify that the welcome screen is displayed.
    expect(find.text('Welcome to Guardify'), findsOneWidget);
    expect(find.text('Your Security Guardian'), findsOneWidget);

    // Verify that security features are listed.
    expect(find.text('🔐 Biometric Authentication'), findsOneWidget);
    expect(find.text('🛡️ Secure Data Storage'), findsOneWidget);
    expect(find.text('🔒 Data Encryption'), findsOneWidget);

    // Test navigation to login
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Verify login screen is displayed
    expect(find.text('Secure Login'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('Login form validation test', (WidgetTester tester) async {
    await tester.pumpWidget(const GuardifyApp());

    // Navigate to login
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Try to login without entering credentials
    await tester.tap(find.text('LOGIN'));
    await tester.pump();

    // Verify validation messages appear
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });
}
