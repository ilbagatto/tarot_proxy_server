import 'package:shelf/shelf.dart';
import 'package:tarot_proxy_server/logger_service.dart';

Middleware corsMiddleware() {
  return (innerHandler) {
    return (request) async {
      final originHeader = request.headers['origin'];
      final uri = originHeader != null ? Uri.tryParse(originHeader) : null;

      // SDtatic white list for production
      const allowedStatic = {
        'https://app.tarot-book.ru',
      };

      // Dynamic resolving of localhost
      final isLocalhost = uri != null &&
        (uri.host == 'localhost' || uri.host == '127.0.0.1');

      final isAllowedOrigin = originHeader != null &&
        (allowedStatic.contains(originHeader) || isLocalhost);

      final headers = {
        ..._baseCorsHeaders,
        if (isAllowedOrigin) 'Access-Control-Allow-Origin': originHeader!,
        if (isAllowedOrigin) 'Vary': 'Origin',
      };

      if (request.method == 'OPTIONS') {
        logger.d('--- CORS DEBUG ---');
        logger.d('Origin: $originHeader, allowed? $isAllowedOrigin');
        logger.d('Response headers: $headers');

        return Response(
          204,
          headers: {
            ...headers,
            'Content-Length': '0',
          },
          context: {'shelf.io.buffer_output': false},
        );
      }

      final response = await innerHandler(request);
      return response.change(headers: headers);
    };
  };
}

const _baseCorsHeaders = {
  'Access-Control-Allow-Methods': 'GET, HEAD, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization',
};
