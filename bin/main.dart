import 'dart:io';

import 'package:tarot_proxy_server/logger_service.dart';
import 'package:tarot_proxy_server/server.dart';

void main() {
  // Disable stdout buffering for real-time log visibility
  stdout.nonBlocking;
  stdout.writeCharCode(0); // optional kickstart
  logger.d('logger.d is working');
  startServer();
}
