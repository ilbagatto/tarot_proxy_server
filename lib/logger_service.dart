import 'package:logger/logger.dart';

final bool isProduction = bool.fromEnvironment('dart.vm.product');

class SimpleLogPrinter extends LogPrinter {
  SimpleLogPrinter();

  @override
  List<String> log(LogEvent event) {
    final now = DateTime.now();
    final timeString = now.toIso8601String();
    final levelString = event.level.toString().split('.').last.toUpperCase();

    return ['$timeString [$levelString] ${event.message}'];
  }
}

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

final logger = Logger(
  filter: MyFilter(),
  level: Level.debug,
  //level: isProduction ? Level.warning : Level.debug,
  printer: SimpleLogPrinter(),
  output: ConsoleOutput(),
);

