import 'package:shelf/shelf.dart';
import 'package:tarot_proxy_server/logger_service.dart';

Middleware customLogRequests() {
  return (Handler innerHandler) {
    return (Request request) async {
      final stopwatch = Stopwatch()..start();

      final response = await innerHandler(request);

      stopwatch.stop();

      logger.i(
        '${request.method} ${request.requestedUri.path}'
        ' → ${response.statusCode} (${stopwatch.elapsedMilliseconds} ms)',
      );

      return response;
    };
  };
}
