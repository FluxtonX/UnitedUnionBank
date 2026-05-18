enum AppEnvironment { development, staging, production }

class AppEnvironmentConfig {
  const AppEnvironmentConfig._();

  static const AppEnvironment current = AppEnvironment.development;

  static bool get isProduction => current == AppEnvironment.production;

  static const int minDepositAmountCents = 100;
  static const int maxDepositAmountCents = 500000;
  static const String defaultCurrency = 'usd';
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
}
