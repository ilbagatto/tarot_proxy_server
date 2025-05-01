import 'package:shelf/shelf.dart';

Middleware corsMiddleware() {
  return (innerHandler) {
    return (request) async {
      final origin = request.headers['origin'];
      final isAllowedOrigin =
          origin != null && _allowedOrigins.contains(origin);

      final headers = {
        ..._baseCorsHeaders,
        if (isAllowedOrigin) 'Access-Control-Allow-Origin': origin,
      };

      if (request.method == 'OPTIONS') {
        return Response(204, headers: headers); // No Content
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
