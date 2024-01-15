import 'dart:io';

import 'package:network/network.dart';

void main() {
  HttpOverrides.global = DevelopmentHttpConfig(
      domains: ['wrong.host.badssl.com'], proxyPort: 8080);
  var awesome = Awesome();
  print('awesome: ${awesome.isAwesome}');
}