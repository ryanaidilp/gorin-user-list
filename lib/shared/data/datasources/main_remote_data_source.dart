// ignore_for_file: one_member_abstracts

import 'package:injectable/injectable.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/local_storage/local_storage.dart';

abstract interface class MainRemoteDataSource {
  Future<bool> checkIfAuthenticated();
}

@LazySingleton(as: MainRemoteDataSource)
class MainRemoteDataSourceImpl implements MainRemoteDataSource {
  MainRemoteDataSourceImpl();

  final LocalStorage _storage = getIt<LocalStorage>(instanceName: 'secure');

  @override
  Future<bool> checkIfAuthenticated() => _storage.has('user');
}
