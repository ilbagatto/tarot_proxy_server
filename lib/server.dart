import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:tarot_proxy_server/middleware/cors_middleware.dart';
import 'package:tarot_proxy_server/middleware/log_requests.dart';
import 'package:tarot_proxy_server/proxy_handler.dart';
import 'package:tarot_proxy_server/config.dart';
import 'package:tarot_proxy_server/logger_service.dart';

Future<void> startServer() async {
  logger.i('Server started');
  await loadEnv();

  final apiBase = getApiBase();
  final username = getApiUsername();
  final password = getApiPassword();

  final handler = Pipeline()
      .addMiddleware(customLogRequests()) // Logging
      .addMiddleware(corsMiddleware())    // CORS handling
      .addHandler((request) => proxyHandler(request, apiBase, username, password));

  final port = int.parse(getPort());

  final server = await serve(handler, InternetAddress.anyIPv4, port);
  logger.i('Proxy server listening on port ${server.port}');
}
