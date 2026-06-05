import 'package:flutter/foundation.dart';

enum AppEnvironment { development, staging, production }

class AppEnvironmentConfig {
  const AppEnvironmentConfig._();

  static const AppEnvironment current = AppEnvironment.production;

  static bool get isProduction => current == AppEnvironment.production;

  static const int minDepositAmountCents = 100;
  static const int maxDepositAmountCents = 500000;
  static const String defaultCurrency = 'usd';
  static const String _configuredApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String get apiBaseUrl {
    if (_configuredApiBaseUrl.isNotEmpty) return _configuredApiBaseUrl;
    return kReleaseMode ? 'http://3.106.133.154' : 'http://10.0.2.2:3000';
  }
}
