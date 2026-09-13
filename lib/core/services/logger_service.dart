import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  static Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    _logger.i('Event: $name, Params: $parameters');
    if (!kDebugMode) {
      await FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
    }
  }

  static Future<void> logError(dynamic error, StackTrace? stack, {String? reason}) async {
    _logger.e('Error: $reason', error: error, stackTrace: stack);
    if (!kDebugMode) {
      await FirebaseCrashlytics.instance.recordError(error, stack, reason: reason);
    }
  }

  static void i(String message) => _logger.i(message);
  static void e(String message, [dynamic error, StackTrace? stack]) => _logger.e(message, error: error, stackTrace: stack);
  static void w(String message) => _logger.w(message);
}
