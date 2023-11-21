import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_list_task/app.dart';
import 'package:user_list_task/config/firebase_options.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/firebase/crashlytics.dart';

void main() => runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        await Future.wait(
          [
            SystemChrome.setPreferredOrientations(
              [
                DeviceOrientation.portraitUp,
              ],
            ),
            configureDependencies(),
            getIt<Crashlytics>().initialize(),
          ],
        );

        runApp(const App());
      },
      (error, stack) => getIt<Crashlytics>().report(error, stack),
    );
