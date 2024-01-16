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
      const badSSLDomain = 'wrong.host.badssl.com';
      const requestDomain = 'wrong.host.badssl.com';
      HttpOverrides.global = DevelopmentHttpConfig(
        domains: [badSSLDomain], /*proxyPort: 8080*/
      );

      final url = Uri.https(requestDomain, '/');
      final response = await http.get(url);
      expect(response.statusCode, equals(200));
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
    });

    test('Fail with wrong exclusion', () async {
      const badSSLDomain = 'apple.com';
      const requestDomain = 'wrong.host.badssl.com';
      HttpOverrides.global = DevelopmentHttpConfig(
        domains: [badSSLDomain], /*proxyPort: 8080*/
      );

      final url = Uri.https(requestDomain, '/');
      // ignore: unawaited_futures
      expectLater(() => http.get(url), throwsException);
    });

    test('Fail Without exclusion', () async {
      const requestDomain = 'wrong.host.badssl.com';

      final url = Uri.https(requestDomain, '/');
      // ignore: unawaited_futures
      expectLater(() => http.get(url), throwsException);
    });
  });
}
