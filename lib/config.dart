import 'package:dotenv/dotenv.dart';

  var _env = DotEnv(includePlatformEnvironment: true)..load();

Future<void> loadEnv() async {
  _env.load();
}

String getApiBase() => _env['API_BASE'] ?? (throw Exception('API_BASE not found in .env'));

String getApiKey() => _env['API_KEY'] ?? (throw Exception('API_KEY not found in .env'));

String getApiUsername() => _env['API_USERNAME'] ?? (throw Exception('API_USERNAME not found in .env'));

String getApiPassword() => _env['API_PASSWORD'] ?? (throw Exception('API_PASSWORD not found in .env'));

String getPort() => _env['PORT'] ?? '3000';
