// ignore_for_file: one_member_abstracts

import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/exceptions/exceptions.dart';
import 'package:user_list_task/core/local_storage/local_storage.dart';
import 'package:user_list_task/shared/data/models/profile.dart';

abstract interface class MainLocalDataSource {
  Future<bool> checkIfAuthenticated();
  Future<Profile> getUserData();
}

@LazySingleton(as: MainLocalDataSource)
class MainLocalDataSourceImpl implements MainLocalDataSource {
  MainLocalDataSourceImpl();

  final LocalStorage _storage = getIt<LocalStorage>(instanceName: 'secure');

  @override
  Future<bool> checkIfAuthenticated() => _storage.has('user');

  @override
  Future<Profile> getUserData() async {
    final data = await _storage.get('user') as String?;

    if (data == null) {
      throw DatabaseException();
    }

    final json = jsonDecode(data) as Map<String, dynamic>;

    return Profile.fromJson(json);
  }
}
