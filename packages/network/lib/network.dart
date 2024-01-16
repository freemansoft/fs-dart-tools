/// Development certificate and proxy support
///
/// Usage in a flutter
/// ```dart
/// if (!kIsWeb && kDebugMode) {
///   HttpOverrides.global = DevelopmentHttpConfig(domains: ['mydomain.com'],
///   proxyPort 8080);
/// }
/// ```

library;

export 'src/network_base.dart';
