import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../network/api_log_interceptor.dart';
import '../services/api_log_service.dart';
import 'injection.config.dart';

/// Global Dependency Injection Container
/// Menggunakan get_it sebagai service locator
final GetIt getIt = GetIt.instance;

bool _isInitialized = false;

/// Initialize all dependencies
/// Panggil fungsi ini di main.dart sebelum runApp()
@InjectableInit()
Future<void> configureDependencies() async {
  if (_isInitialized) {
    print('⚠️ GetIt already initialized, skipping...');
    return;
  }
  
  print('🔧 Initializing Dependency Injection Container...');
  
  // Initialize semua module dengan injectable
  await getIt.init();
  
  // Setup API log interceptor setelah dependencies diinisialisasi
  _setupApiLogInterceptor();
  
  _isInitialized = true;
  print('✅ Dependency Injection Container ready');
}

/// Setup API log interceptor untuk Dio
void _setupApiLogInterceptor() {
  try {
    final dio = getIt<Dio>();
    final logService = getIt<ApiLogService>();
    dio.interceptors.add(ApiLogInterceptor(logService));
    print('✅ API Log Interceptor configured');
  } catch (e) {
    print('⚠️ Failed to setup API Log Interceptor: $e');
  }
}

/// Reset DI Container (untuk testing)
void resetDependencies() {
  getIt.reset();
  _isInitialized = false;
}
