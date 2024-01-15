import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:network/network.dart';
import 'package:test/test.dart';

/// an integration test that needs internet access
void main() async {
  group('A group of tests', () {
    setUp(() {
// the exclusion stays set
      HttpOverrides.global = null;
    });

    test('Succeed with an exclusion', () async {
      final badSSLDomain = 'wrong.host.badssl.com';
      HttpOverrides.global = DevelopmentHttpConfig(
        domains: [badSSLDomain], /*proxyPort: 8080*/
      );

      var url = Uri.https(badSSLDomain, '/');
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    });

    test('Fail Without exclusion', () async {
      final badSSLDomain = 'wrong.host.badssl.com';

      var url = Uri.https(badSSLDomain, '/');
      expectLater(() => http.get(url), throwsException);
    });
  });
}
