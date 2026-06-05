import 'package:flutter/foundation.dart';

enum AppEnvironment { development, staging, production }

class AppEnvironmentConfig {
  const AppEnvironmentConfig._();

  static const AppEnvironment current = AppEnvironment.production;

  static bool get isProduction => current == AppEnvironment.production;
  static bool get isDevelopment => current == AppEnvironment.development;
  static bool get isStaging => current == AppEnvironment.staging;

  static const int minDepositAmountCents = 100;
  static const int maxDepositAmountCents = 500000;
  static const String defaultCurrency = 'usd';

  static const String _configuredApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String get apiBaseUrl {
    if (_configuredApiBaseUrl.trim().isNotEmpty) {
      return _configuredApiBaseUrl.trim();
    }

    switch (current) {
      case AppEnvironment.production:
        return 'http://3.106.133.154';

      case AppEnvironment.staging:
        return 'http://3.106.133.154';

      case AppEnvironment.development:
        if (kIsWeb) {
          return 'http://localhost:3000';
        }

        if (defaultTargetPlatform == TargetPlatform.android) {
          // Android emulator = 10.0.2.2
          // Real Android device: use --dart-define=API_BASE_URL=http://YOUR_LAPTOP_IP:3000
          return 'http://10.0.2.2:3000';
        }

        return 'http://localhost:3000';
    }
  }
}