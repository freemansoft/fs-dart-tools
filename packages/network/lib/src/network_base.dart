import 'dart:io';

///
/// ignores cert in developermode for limited set of domains
/// Simplifies development in corporate self signed environment
/// Configures the emulator or simulator proxy if passed proxy port.
/// Assumes there is a proxy running locally if proxy port provided
///
class DevelopmentHttpConfig extends HttpOverrides {
  DevelopmentHttpConfig({required this.domains, this.proxyPort});

  /// list of domains we exclude from cert check
  List<String> domains;

  /// proxyPort != null means setup the proxy if isAndroid or isIOS
  int? proxyPort;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final exclusion = super.createHttpClient(context);

    // ignore self signed certs in these domains
    exclusion.badCertificateCallback =
        (cert, host, port) => domains.any((element) => host.endsWith(element));

    if (proxyPort != null) {
      if (Platform.isAndroid) {
        exclusion.findProxy = (url) => 'PROXY 10.0.2.2:$proxyPort';
      }
      if (Platform.isIOS) {
        exclusion.findProxy = (url) => 'Proxy 127.0.0.1:$proxyPort';
      }
    }
    return exclusion;
  }
}
