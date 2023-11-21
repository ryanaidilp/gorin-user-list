import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class Crashlytics {
  const Crashlytics(this._crashlytics);

  String get _logPrefix => 'Analytics: ';

  final FirebaseCrashlytics _crashlytics;

  Future<void> initialize() async {
    if (kDebugMode) {
      await _crashlytics.setCrashlyticsCollectionEnabled(false);
      log('${_logPrefix}Disabled');
    } else {
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
      log('${_logPrefix}Enabled');

      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      PlatformDispatcher.instance.onError = (error, stack) {
        report(error, stack);
        return true;
      };
    }
  }

  Future<void> setUserIdentifier(String identifier) async {
    await _crashlytics.setUserIdentifier(identifier);
    log('${_logPrefix}User Identifier set to $identifier');
  }

  Future<void> report(dynamic error, StackTrace trace, {bool fatal = false}) =>
      _crashlytics.recordError(
        error,
        trace,
        fatal: fatal,
      );
}
