import 'package:shelf/shelf.dart';

Middleware corsMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      // Handle preflight (OPTIONS) requests immediately
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders());
      }

      // For other requests, process normally and add CORS headers to the response
      final response = await innerHandler(request);

      return response.change(headers: {
        ...response.headers,
        ..._corsHeaders(),
      });
    };
  };
}

// Centralized CORS headers
Map<String, String> _corsHeaders() => {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, HEAD, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization',
};
