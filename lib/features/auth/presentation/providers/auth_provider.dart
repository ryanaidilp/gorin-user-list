import 'package:flutter/material.dart';
import 'package:user_list_task/base/base_state.dart';
import 'package:user_list_task/base/use_case.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/features/auth/domain/usecases/login.dart';
import 'package:user_list_task/features/auth/domain/usecases/logout.dart';
import 'package:user_list_task/shared/domain/entities/profile_entity.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    BaseState<ProfileEntity>? loginState,
    BaseState<bool>? logoutState,
  })  : loginState = loginState ?? const BaseState<ProfileEntity>(),
        logoutState = logoutState ?? const BaseState();

  BaseState<ProfileEntity> loginState;
  BaseState<bool> logoutState;
  final Login _login = getIt<Login>();
  final Logout _logout = getIt<Logout>();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    loginState = loginState.copyWith(
      status: DataStatus.loading,
    );
    notifyListeners();

    final result = await _login.call(
      LoginParam(
        email: email,
        password: password,
      ),
    );

    result.fold(
      (l) {
        loginState = loginState.copyWith(
          status: DataStatus.error,
          message: l.message,
        );
        notifyListeners();
      },
      (r) {
        loginState = loginState.copyWith(
          status: DataStatus.success,
          data: r,
        );
        notifyListeners();
      },
    );
  }

  Future<void> logout() async {
    logoutState = logoutState.copyWith(
      status: DataStatus.loading,
    );
    notifyListeners();

    final result = await _logout.call(NoParams());

    result.fold(
      (l) {
        logoutState = logoutState.copyWith(
          status: DataStatus.error,
          message: l.message,
        );
        notifyListeners();
      },
      (r) {
        logoutState = logoutState.copyWith(
          status: DataStatus.success,
          data: r,
        );
        notifyListeners();
      },
    );
  }

  void reset() {
    loginState = loginState.copyWith(status: DataStatus.initial);
    logoutState = logoutState.copyWith(status: DataStatus.initial);
    notifyListeners();
  }
}
