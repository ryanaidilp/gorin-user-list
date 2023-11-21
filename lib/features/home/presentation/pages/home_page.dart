import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:user_list_task/base/base_state.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/messenger/messenger.dart';
import 'package:user_list_task/features/auth/presentation/providers/auth_provider.dart';
import 'package:user_list_task/router/app_router.dart';
import 'package:user_list_task/shared/presentation/providers/app_data_provider.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AppDataProvider>(
          builder: (_, provider, __) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                provider.loadUserData();
              },
            );
            return Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CircleAvatar(
                    child: provider.user?.avatar == null
                        ? const SpinKitFadingCircle(
                            size: 25,
                            color: Colors.blueAccent,
                          )
                        : Image.network(
                            provider.user?.avatar ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.user?.name ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        provider.user?.email ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          Consumer<AuthProvider>(
            builder: (_, provider, __) {
              WidgetsBinding.instance.addPersistentFrameCallback(
                (_) => _logoutStateListener(provider),
              );
              final state = provider.logoutState;
              return IconButton(
                onPressed:
                    state.status == DataStatus.loading ? null : provider.logout,
                icon: state.status == DataStatus.loading
                    ? const SpinKitFadingCircle(
                        color: Colors.blueAccent,
                        size: 25,
                      )
                    : const Icon(
                        Icons.logout,
                      ),
              );
            },
          ),
        ],
      ),
      body: Container(),
    );
  }

  void _logoutStateListener(AuthProvider provider) {
    if (provider.logoutState.status == DataStatus.error) {
      getIt<MessengerService>().showPersistentSnackbar(
        message: provider.logoutState.message ?? '',
        context: context,
        state: SnackbarState.error,
      );
    } else if (provider.logoutState.status == DataStatus.success) {
      if (context.mounted) {
        getIt<MessengerService>().showPersistentSnackbar(
          message: 'Logout success!',
          context: context,
          state: SnackbarState.success,
        );
        provider.reset();
        context.router.replaceAll([const SignInRoute()]);
      }
    }
  }
}
