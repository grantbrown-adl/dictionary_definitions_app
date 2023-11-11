import 'package:logger/logger.dart';

Logger logger() => defaultLogger;

/// Default logger used throughout the app
final defaultLogger = Logger(
  printer: PrettyPrinter(
    printEmojis: false,
    excludeBox: {
      Level.info: true,
      Level.debug: true,
      Level.trace: true,
    },
    // Omit stack traces from logs (too much clutter for general use)
    methodCount: 0,
  ),
  filter: _Filter(),
);

class _Filter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return event.error.runtimeType.toString() != 'TestError';
  }
}
