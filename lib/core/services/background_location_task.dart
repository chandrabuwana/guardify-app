// Temporarily disabled due to Kotlin 2.1.0 compatibility issue with workmanager 0.5.2
// All imports removed since workmanager is not in pubspec.yaml
// TODO: Re-add imports when workmanager is updated to 0.9.0+3

/// Background task handler untuk update lokasi
/// Task ini akan dijalankan setiap 15 menit
/// Note: Workmanager runs in a separate isolate, so we can't use GetIt
/// We need to create dependencies manually here
/// 
/// TEMPORARILY DISABLED: workmanager 0.5.2 is not compatible with Kotlin 2.1.0
/// TODO: Update to workmanager 0.9.0+3 when ready (requires code changes)
@pragma('vm:entry-point')
void callbackDispatcher() {
  // Temporarily disabled - workmanager compatibility issue
  // This function will be re-enabled when workmanager is updated
  print('⚠️ [BackgroundTask] Workmanager callback disabled (Kotlin 2.1.0 compatibility issue)');
}

/// Helper class untuk mengelola background task
class BackgroundLocationTaskManager {
  static const String taskName = 'locationUpdateTask';
  
  /// Initialize dan register background task
  /// TEMPORARILY DISABLED: workmanager 0.5.2 is not compatible with Kotlin 2.1.0
  static Future<void> initialize() async {
    // Temporarily disabled - workmanager compatibility issue
    print('⚠️ [BackgroundTask] Workmanager initialization disabled (Kotlin 2.1.0 compatibility issue)');
    print('⚠️ [BackgroundTask] Background location updates will not work until workmanager is updated');
    return;
    /*
    // Original code - will be re-enabled when workmanager is updated
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false, // Set to true for debugging
    );
    
    print('🔄 [BackgroundTask] Workmanager initialized');
    */
  }
  
  /// Register periodic task untuk update lokasi setiap 15 menit
  /// TEMPORARILY DISABLED: workmanager 0.5.2 is not compatible with Kotlin 2.1.0
  static Future<void> registerPeriodicTask() async {
    // Temporarily disabled - workmanager compatibility issue
    print('⚠️ [BackgroundTask] Periodic task registration disabled (Kotlin 2.1.0 compatibility issue)');
    return;
    /*
    // Original code - will be re-enabled when workmanager is updated
    await Workmanager().registerPeriodicTask(
      taskName,
      taskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
      initialDelay: const Duration(minutes: 1), // Start after 1 minute
    );
    
    print('🔄 [BackgroundTask] Periodic task registered (every 15 minutes)');
    */
  }
  
  /// Cancel background task
  /// TEMPORARILY DISABLED: workmanager 0.5.2 is not compatible with Kotlin 2.1.0
  static Future<void> cancelTask() async {
    // Temporarily disabled
    print('⚠️ [BackgroundTask] Task cancellation disabled');
    return;
    /*
    // Original code - will be re-enabled when workmanager is updated
    await Workmanager().cancelByUniqueName(taskName);
    print('🔄 [BackgroundTask] Task cancelled');
    */
  }
  
  /// Check if task is registered
  static Future<bool> isTaskRegistered() async {
    // Workmanager doesn't have a direct way to check if task is registered
    // We'll just try to register it, which will replace existing one if any
    return false; // Always return false since workmanager is disabled
  }
}
