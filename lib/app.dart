import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/messenger/messenger.dart';
import 'package:user_list_task/features/auth/presentation/providers/auth_provider.dart';
import 'package:user_list_task/features/kyc/presentation/providers/kyc_provider.dart';
import 'package:user_list_task/router/app_router.dart';
import 'package:user_list_task/shared/presentation/providers/app_data_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AppDataProvider()..checkIfAuthenticated(),
          ),
          ChangeNotifierProvider(
            create: (_) => AuthProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => KYCProvider(),
          ),
        ],
        child: MaterialApp.router(
          title: 'Gorin Test',
          debugShowCheckedModeBanner: false,
          routerDelegate: AutoRouterDelegate(
            getIt<AppRouter>(),
          ),
          routeInformationParser: getIt<AppRouter>().defaultRouteParser(),
          scaffoldMessengerKey:
              getIt<MessengerService>().rootScaffoldMessengerKey,
        ),
      );
}
