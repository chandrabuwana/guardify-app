import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardify_app/core/di/injection.dart';
import 'package:guardify_app/features/cuti/presentation/bloc/cuti_bloc.dart';
import 'package:guardify_app/features/cuti/domain/repositories/cuti_repository.dart';
import 'package:guardify_app/features/cuti/domain/usecases/get_cuti_kuota.dart';

void main() {
  group('Cuti Dependency Injection Tests', () {
    setUpAll(() async {
      // Initialize Flutter binding
      TestWidgetsFlutterBinding.ensureInitialized();

      // Mock platform channels that SharedPreferences needs
      const MethodChannel('plugins.flutter.io/shared_preferences')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getAll') {
          return <String, Object>{}; // Return empty preferences
        }
        return null;
      });

      // Initialize dependency injection
      await configureDependencies();
    });

    test('Should resolve CutiBloc from GetIt', () {
      // Act
      final cutiBloc = getIt<CutiBloc>();

      // Assert
      expect(cutiBloc, isA<CutiBloc>());
    });

    test('Should resolve CutiRepository from GetIt', () {
      // Act
      final cutiRepository = getIt<CutiRepository>();

      // Assert
      expect(cutiRepository, isA<CutiRepository>());
    });

    test('Should resolve GetCutiKuota usecase from GetIt', () {
      // Act
      final getCutiKuota = getIt<GetCutiKuota>();

      // Assert
      expect(getCutiKuota, isA<GetCutiKuota>());
    });

    test('Should create multiple instances of factory-registered classes', () {
      // Act
      final cutiBloc1 = getIt<CutiBloc>();
      final cutiBloc2 = getIt<CutiBloc>();

      // Assert - Factory should create new instances
      expect(cutiBloc1, isNot(same(cutiBloc2)));
    });

    test('Should return same instance for singleton-registered classes', () {
      // Act
      final repository1 = getIt<CutiRepository>();
      final repository2 = getIt<CutiRepository>();

      // Assert - Singleton should return same instance
      expect(repository1, same(repository2));
    });
  });
}
