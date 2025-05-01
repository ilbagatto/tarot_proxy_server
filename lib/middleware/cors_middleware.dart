import 'package:shelf/shelf.dart';
import 'package:tarot_proxy_server/logger_service.dart';

Middleware corsMiddleware() {
  return (innerHandler) {
    return (request) async {
      final origin = request.headers['origin'];
      final isAllowedOrigin =
          origin != null && _allowedOrigins.contains(origin);

      final headers = {
        ..._baseCorsHeaders,
        if (isAllowedOrigin) 'Access-Control-Allow-Origin': origin,
        if (isAllowedOrigin) 'Vary': 'Origin',
      };

      if (request.method == 'OPTIONS') {
        logger.d('--- CORS DEBUG ---');
        logger.d('Origin header: $origin');
        logger.d('Is allowed: $isAllowedOrigin');
        logger.d('Final headers: $headers');

        final optionsHeaders = {
          ...headers,
          'Content-Length': '0',
        };

        return Response(
          204,
          headers: optionsHeaders,
          context: {'shelf.io.buffer_output': false},
        );
      }

      final response = await innerHandler(request);
      return response.change(headers: headers);
    };
  };
}

const _allowedOrigins = {
  'https://app.tarot-book.ru',
  'http://localhost:5173', // for Vite/Flutter Web
  'http://localhost:12345', // standard Flutter dev server
};

const _baseCorsHeaders = {
  'Access-Control-Allow-Methods': 'GET, HEAD, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization',
};
