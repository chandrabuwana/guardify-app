import 'package:flutter/material.dart';
import 'features/auth/domain/usecases/login_use_case.dart';

void main() {
  runApp(const GuardifyTestApp());
}

class GuardifyTestApp extends StatelessWidget {
  const GuardifyTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guardify Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const TestPage(),
    );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Guardify - Error Fixed!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              'Error "Failure type" sudah diperbaiki!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Project Flutter Guardify.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _testValidation(context);
              },
              child: const Text('Test Validation'),
            ),
          ],
        ),
      ),
    );
  }

  void _testValidation(BuildContext context) {
    // Test the validators from our use case
    final emailValidation = Validators.validateEmail('test@example.com');
    final passwordValidation = Validators.validatePassword('password123');

    String message = 'Validation Test:\n';
    message += 'Email: ${emailValidation ?? 'Valid ✓'}\n';
    message += 'Password: ${passwordValidation ?? 'Valid ✓'}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
