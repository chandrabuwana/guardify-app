import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
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
  
  _isInitialized = true;
  print('✅ Dependency Injection Container ready');
}

/// Reset DI Container (untuk testing)
void resetDependencies() {
  getIt.reset();
  _isInitialized = false;
}
