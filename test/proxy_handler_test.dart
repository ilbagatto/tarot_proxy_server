import 'package:test/test.dart';
import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'dart:convert';

import 'package:tarot_proxy_server/proxy_handler.dart'; // Путь адаптировать

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('ProxyHandler', () {
    const apiBase = 'https://fake-api.com';
    const username = 'user';
    const password = 'pass';

    late MockHttpClient mockClient;

    setUpAll(() {
      registerFallbackValue(Uri.parse('http://localhost/'));
    });

    setUp(() {
      mockClient = MockHttpClient();
    });

    test('Proxies GET request with query parameters correctly', () async {
      // Arrange
      final request = Request(
        'GET',
        Uri.parse('http://localhost/cards/major/1?deck=1&source=2'),
      );

      final responseFromApi = http.Response(
        jsonEncode({'ok': true}),
        200,
        headers: {'content-type': 'application/json'},
      );

      // Mock the http call
      when(
        () => mockClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => responseFromApi);

      // Act
      final response = await proxyHandler(
        request,
        apiBase,
        username,
        password,
        client: mockClient,
      );

      // Assert
      expect(response.statusCode, equals(200));
      final body = await response.readAsString();
      expect(body, contains('"ok":true'));

      // Verify that correct target URL was built
      final captured =
          verify(
            () => mockClient.get(captureAny(), headers: any(named: 'headers')),
          ).captured;
      final Uri proxiedUri = captured.first as Uri;
      expect(proxiedUri.path, equals('/cards/major/1'));
      expect(proxiedUri.queryParameters['deck'], equals('1'));
      expect(proxiedUri.queryParameters['source'], equals('2'));
    });
  });
}
