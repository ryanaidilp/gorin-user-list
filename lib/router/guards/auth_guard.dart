import 'package:auto_route/auto_route.dart';
import 'package:user_list_task/base/use_case.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/router/app_router.dart';
import 'package:user_list_task/shared/domain/usecases/check_if_authenticated.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final result = await getIt<CheckIfAuthenticated>().call(
      NoParams(),
    );

    result.fold(
      (l) => router.replace(const SignInRoute()),
      (r) => r ? resolver.next() : router.replace(const SignInRoute()),
    );
  }
}
