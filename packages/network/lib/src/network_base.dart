import 'dart:io';

///
/// Ignores certificates in developermode for limited set of domains
/// Simplifies development in corporate self signed environment
/// Configures the emulator or simulator proxy if passed proxy port.
/// Assumes there is a proxy running locally if proxy port provided
/// Proxy only used for mobile devices. We assume browser is already configured.
///
class DevelopmentHttpConfig extends HttpOverrides {
  DevelopmentHttpConfig({
    required this.certExclusionDomains,
    this.iosProxyHost = '127.0.0.1',
    this.androidProxyHost = '10.0.2.2',
    this.proxyPort,
  });

  /// Proxy used for android
  /// Defaults to the 10.0.2.x network
  String androidProxyHost;

  /// Proxy used for IOS because it uses the host network. defaults to 127.0.0.1
  /// Android has its own network
  String iosProxyHost;

  /// list of domains we exclude from cert check
  List<String> certExclusionDomains;

  /// proxyPort != null means setup the proxy if isAndroid or isIOS
  int? proxyPort;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final exclusion = super.createHttpClient(context);

    // ignore self signed certs in these domains
    exclusion.badCertificateCallback = (cert, host, port) =>
        certExclusionDomains.any((element) => host.endsWith(element));

    if (proxyPort != null) {
      if (Platform.isAndroid) {
        exclusion.findProxy = (url) => 'PROXY $androidProxyHost:$proxyPort';
      }
      if (Platform.isIOS) {
        exclusion.findProxy = (url) => 'Proxy $iosProxyHost:$proxyPort';
      }
    }
    return exclusion;
  }
}
