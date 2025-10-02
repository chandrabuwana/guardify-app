import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardify_app/core/di/injection.dart';
import 'package:guardify_app/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:guardify_app/features/patrol/presentation/bloc/patrol_bloc.dart';
import 'package:guardify_app/features/patrol/presentation/bloc/attendance_bloc.dart';

void main() {
  group('Patrol Module Dependencies Test', () {
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

    test('should be able to get PatrolBloc from GetIt', () {
      // Act & Assert
      expect(() => getIt<PatrolBloc>(), isNot(throwsA(anything)));
    });

    test('should be able to get AttendanceBloc from GetIt', () {
      // Act & Assert
      expect(() => getIt<AttendanceBloc>(), isNot(throwsA(anything)));
    });
  });
}