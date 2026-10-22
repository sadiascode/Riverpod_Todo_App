import 'package:flutter/foundation.dart';

/// Lightweight logging facade used across the app.
///
/// In debug builds messages are forwarded to the regular console so they
/// remain visible while developing. In release builds we deliberately stay
/// silent to avoid leaking sensitive transport details into the wild; a
/// real backend (Crashlytics / Sentry) can be wired in later without
/// touching call sites.
class Logger {
  const Logger._();

  /// Logs a free-form informational message.
  static void log(String message) {
    if (kDebugMode) {
      print('[LOG] $message');
    }
  }

  /// Logs an error along with the originating [error] object and optional
  /// [stackTrace]. Use this anywhere we swallow a transport / domain
  /// failure but still want the full details for diagnostics.
  ///
  /// Callers are expected to surface a user-friendly message to the UI
  /// separately; this method only emits developer-facing detail.
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('[ERROR] $message');
      if (error != null) {
        print('[ERROR]   cause: $error');
      }
      if (stackTrace != null) {
        print('[ERROR]   stack:\n$stackTrace');
      }
    }
  }
}
