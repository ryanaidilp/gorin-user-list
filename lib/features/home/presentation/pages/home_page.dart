import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:user_list_task/base/base_state.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/firebase/firestore.dart';
import 'package:user_list_task/core/messenger/messenger.dart';
import 'package:user_list_task/features/auth/presentation/providers/auth_provider.dart';
import 'package:user_list_task/router/app_router.dart';
import 'package:user_list_task/shared/presentation/providers/app_data_provider.dart';

@RoutePage()
class HomePage extends StatelessWidget {
   HomePage({super.key});

  final _usersStream = getIt<Firestore>().getAllUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Consumer<AppDataProvider>(
          builder: (_, provider, __) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                provider.loadUserData();
              },
            );
            return Row(
              children: [
                CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
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
                (_) => _logoutStateListener(provider, context),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child:
                  Text('There is something wrong when try to load the data!'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitFadingCircle(
                size: 25,
                color: Colors.blueAccent,
              ),
            );
          }

          return ListView.separated(
            itemCount: snapshot.requireData.docs.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, index) {
              final item = snapshot.requireData.docs[index];
              final data = item.data() as Map<String, dynamic>?;
              return ListTile(
                leading: CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: data?['avatar'] == null
                        ? const SpinKitFadingCircle(
                            size: 25,
                            color: Colors.blueAccent,
                          )
                        : Image.network(
                            data?['avatar'].toString() ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
                title: Text('${data?['name']}'),
                subtitle: Text('${data?['email']}'),
              );
            },
          );
        },
      ),
    );
  }

  void _logoutStateListener(AuthProvider provider, BuildContext context) {
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
