import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/local_storage/local_storage.dart';
import 'package:user_list_task/shared/data/models/profile.dart';

abstract class AuthLocalDataSource {
  Future<Profile> getUserData();
  Future<bool> storeUserData(Profile profile);
  Future<bool> deleteUserData();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final _storage = getIt<LocalStorage>(instanceName: 'secure');

  @override
  Future<bool> deleteUserData() => _storage.remove('user');

  @override
  Future<Profile> getUserData() async {
    final data = await _storage.get('user') as String;
    final json = jsonDecode(data) as Map<String, dynamic>;
    return Profile.fromJson(json);
  }

  @override
  Future<bool> storeUserData(Profile profile) async {
    final json = profile.toJson();
    return _storage.save(
      'user',
      jsonEncode(json),
    );
  }
}
