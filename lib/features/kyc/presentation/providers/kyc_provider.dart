import 'dart:io';

import 'package:flutter/material.dart';
import 'package:user_list_task/base/base_state.dart';

import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/features/kyc/domain/usecases/register.dart';
import 'package:user_list_task/shared/domain/entities/profile_entity.dart';

class KYCProvider extends ChangeNotifier {
  KYCProvider({BaseState<ProfileEntity>? state})
      : state = state ?? const BaseState();

  BaseState<ProfileEntity> state;
  final _register = getIt<Register>();

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required File avatar,
  }) async {
    state = state.copyWith(
      status: DataStatus.loading,
    );

    notifyListeners();

    final result = await _register.call(
      RegisterParam(
        email: email,
        password: password,
        name: name,
        avatar: avatar,
      ),
    );

    return result.fold(
      (l) {
        state = state.copyWith(
          status: DataStatus.error,
          message: l.message,
        );
        notifyListeners();
      },
      (r) {
        state = state.copyWith(
          status: DataStatus.success,
          data: r,
        );
        notifyListeners();
      },
    );
  }

  void reset() {
    state = state.copyWith(status: DataStatus.initial);
    notifyListeners();
  }
}
