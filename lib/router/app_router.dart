// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:user_list_task/features/auth/presentation/pages/sign_in_page.dart';
import 'package:user_list_task/features/home/presentation/pages/home_page.dart';
import 'package:user_list_task/features/home/presentation/pages/profile_page.dart';
import 'package:user_list_task/features/kyc/presentation/pages/sign_up_page.dart';
import 'package:user_list_task/features/startup/presentation/pages/startup_page.dart';
import 'package:user_list_task/router/guards/auth_guard.dart';
import 'package:user_list_task/router/guards/guest_guard.dart';
import 'package:user_list_task/router/wrappers/page_wrapper.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
@LazySingleton()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: RouteWrapper.page,
          children: [
            AutoRoute(
              initial: true,
              path: 'splash',
              page: StartupRoute.page,
            ),
              AutoRoute(
              path: 'sign-up',
              guards: [
                GuestGuard(),
              ],
              page: SignUpRoute.page,
            ),
            AutoRoute(
              path: 'sign-in',
              guards: [
                GuestGuard(),
              ],
              page: SignInRoute.page,
            ),
            AutoRoute(
              path: 'home',
              guards: [
                AuthGuard(),
              ],
              page: HomeRoute.page,
            ),
          ],
        ),
      
      ];
}
