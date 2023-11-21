import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/router/app_router.dart';
import 'package:user_list_task/shared/presentation/providers/app_data_provider.dart';

@RoutePage()
class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    try {
      await Future.delayed(
        const Duration(seconds: 2),
        () {
          final provider = Provider.of<AppDataProvider>(context, listen: false);

          if (provider.isAuthenticated) {
            getIt<AppRouter>().replace(const HomeRoute());
          } else {
            getIt<AppRouter>().replace(const SignInRoute());
          }
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (_) {
          return const Stack(
            children: [
              Center(
                child: Text(
                  'Gorin Test App',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: SpinKitFadingCircle(
                  size: 25,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
