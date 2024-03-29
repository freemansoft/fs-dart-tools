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
      const excludedCertDomain = 'wrong.host.badssl.com';
      const requestDomain = 'wrong.host.badssl.com';
      HttpOverrides.global = DevelopmentHttpConfig(
        certExclusionDomains: [excludedCertDomain], /*proxyPort: 8080*/
      );

      final url = Uri.https(requestDomain, '/');
      final response = await http.get(url);
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    test('Fail Without exclusion', () async {
      const requestDomain = 'wrong.host.badssl.com';

      final url = Uri.https(requestDomain, '/');
      // ignore: unawaited_futures
      expectLater(() => http.get(url), throwsException);
    });

    test('Fail with wrong exclusion', () async {
      const excludedCertDomain = 'apple.com';
      const requestDomain = 'wrong.host.badssl.com';
      HttpOverrides.global = DevelopmentHttpConfig(
        certExclusionDomains: [excludedCertDomain], /*proxyPort: 8080*/
      );

      final url = Uri.https(requestDomain, '/');
      // ignore: unawaited_futures
      expectLater(() => http.get(url), throwsException);
    });
  });
}
