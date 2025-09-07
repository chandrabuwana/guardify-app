import 'dart:io';

enum EnvironmentType { development, staging, production }

// final NavigationService _navigationService = NavigationService();
// final Alice alice = Alice(
//         showInspectorOnShake: true,
//         navigatorKey: _navigationService.navigatorKey);

/// Environment configuration that enables you to define and read
/// environment specific properties (such as API endpoints, server secrets, ...)
class EnvironmentConfig {
  /// region Environments

  const EnvironmentConfig.development()
      : environment = EnvironmentType.development,
        androidBaseUrl = 'https://qrisdb-bjbs-v2.ihsansolusi.co.id',
        iosBaseUrl = 'https://qrisdb-bjbs-v2.ihsansolusi.co.id';
  // androidBaseUrl = 'https://m-dev.bjbs.id:13500/mbank',
  // iosBaseUrl = 'https://m-dev.bjbs.id:13500/mbank';

  const EnvironmentConfig.staging()
      : environment = EnvironmentType.staging,
        androidBaseUrl = 'https://mbank-stag.bjbs.id',
        iosBaseUrl = 'https://mbank-stag.bjbs.id';

  const EnvironmentConfig.production()
      : environment = EnvironmentType.production,
        androidBaseUrl = 'https://mobile2.bjbs.co.id',
        iosBaseUrl = 'https://mobile2.bjbs.co.id';

  ///endregion

  final EnvironmentType environment;
  final String androidBaseUrl;
  final String iosBaseUrl;

  static late EnvironmentType environmentType;

  String get baseUrl => Platform.isIOS ? iosBaseUrl : androidBaseUrl;
}
