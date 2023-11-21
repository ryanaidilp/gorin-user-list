import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Gorin Test',
        debugShowCheckedModeBanner: false,
        routerDelegate: AutoRouterDelegate(
          getIt<AppRouter>(),
        ),
        routeInformationParser: getIt<AppRouter>().defaultRouteParser(),
      );
}
