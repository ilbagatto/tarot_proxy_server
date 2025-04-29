import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:tarot_proxy_server/logger_service.dart';

Future<Response> proxyHandler(
  Request request,
  String apiBase,
  String username,
  String password, {
  http.Client? client, 
}) async {
  final httpClient = client ?? http.Client(); 

  try {
    // Строим целевой URL
    final targetUrl = Uri.parse(
      '$apiBase${request.requestedUri.path}'
      '${request.requestedUri.hasQuery ? '?${request.requestedUri.query}' : ''}'
    );

    logger.i('Proxying request to: $targetUrl');

    final credentials = base64Encode(utf8.encode('$username:$password'));

    final response = await httpClient.get(
      targetUrl,
      headers: {
        'Authorization': 'Basic $credentials',
      },
    );

    logger.i('Received response: ${response.statusCode}');

    return Response(
      response.statusCode,
      body: request.method == 'HEAD' ? null : response.body,
      headers: {
        'content-type': response.headers['content-type'] ?? 'application/json',
      },
    );
  } catch (e, stackTrace) {
    logger.e('Proxy error', error: e, stackTrace: stackTrace);
    return Response.internalServerError(body: 'Proxy server error');
  } finally {
    if (client == null) {
      httpClient.close(); 
    }
  }
}
