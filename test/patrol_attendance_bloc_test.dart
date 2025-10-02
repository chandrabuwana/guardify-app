import 'package:flutter_test/flutter_test.dart';
import 'package:guardify_app/core/di/injection.dart';
import 'package:guardify_app/features/patrol/presentation/bloc/attendance_bloc.dart';

void main() {
  group('PatrolAttendanceBloc Test', () {
    test('should be able to create PatrolAttendanceBloc from DI', () {
      // Setup dependency injection
      configureDependencies();

      // Test that PatrolAttendanceBloc can be created
      expect(() => getIt<PatrolAttendanceBloc>(), returnsNormally);
      
      // Verify that the bloc is not null
      final bloc = getIt<PatrolAttendanceBloc>();
      expect(bloc, isNotNull);
      expect(bloc, isA<PatrolAttendanceBloc>());
      
      // Clean up
      bloc.close();
    });
  });
}