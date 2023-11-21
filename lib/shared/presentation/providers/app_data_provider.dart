import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:user_list_task/base/use_case.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/shared/domain/entities/profile_entity.dart';
import 'package:user_list_task/shared/domain/usecases/check_if_authenticated.dart';
import 'package:user_list_task/shared/domain/usecases/get_user_data.dart';

class AppDataProvider extends ChangeNotifier {
  AppDataProvider({this.isAuthenticated = false, this.user});
  bool isAuthenticated;
  ProfileEntity? user;

  final CheckIfAuthenticated _checkIfAuthenticated =
      getIt<CheckIfAuthenticated>();
  final GetUserData _getUserData = getIt<GetUserData>();

  Future<void> checkIfAuthenticated() async {
    final result = await _checkIfAuthenticated.call(NoParams());

    result.fold(
      (l) => null,
      (r) {
        isAuthenticated = r;
        notifyListeners();
      },
    );
  }

  Future<void> loadUserData() async {
    final result = await _getUserData.call(NoParams());

    result.fold(
      (l) => log(l.message),
      (r) {
        user = r;
        notifyListeners();
      },
    );
  }
}
