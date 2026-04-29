enum AppEnvironment { dev, prod }

class AppConfig {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableFirebase,
  });

  final AppEnvironment environment;
  final String apiBaseUrl;
  final bool enableFirebase;

  static const AppConfig dev = AppConfig(
    environment: AppEnvironment.dev,
    apiBaseUrl: 'https://dev.api.example.com',
    enableFirebase: false,
  );

  static const AppConfig prod = AppConfig(
    environment: AppEnvironment.prod,
    apiBaseUrl: 'https://api.example.com',
    enableFirebase: true,
  );

  static AppConfig fromEnvironment() {
    final rawEnvironment = const String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'dev',
    );

    final environment = rawEnvironment.toLowerCase() == 'prod'
        ? AppEnvironment.prod
        : AppEnvironment.dev;

    final defaultConfig = environment == AppEnvironment.prod
        ? AppConfig.prod
        : AppConfig.dev;

    final rawBaseUrl = const String.fromEnvironment('API_BASE_URL');
    final apiBaseUrl = rawBaseUrl.isEmpty
        ? defaultConfig.apiBaseUrl
        : rawBaseUrl;

    final enableFirebase = const bool.fromEnvironment(
      'ENABLE_FIREBASE',
      defaultValue: false,
    );

    return AppConfig(
      environment: environment,
      apiBaseUrl: apiBaseUrl,
      enableFirebase: enableFirebase,
    );
  }
}
