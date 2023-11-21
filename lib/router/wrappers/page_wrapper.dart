import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_list_task/shared/presentation/providers/app_data_provider.dart';

@RoutePage()
class PageWrapper extends StatelessWidget implements AutoRouteWrapper {
  const PageWrapper({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AppDataProvider()..checkIfAuthenticated(),
          ),
        ],
        child: const AutoRouter(),
      );

  @override
  Widget wrappedRoute(BuildContext context) => this;
}
