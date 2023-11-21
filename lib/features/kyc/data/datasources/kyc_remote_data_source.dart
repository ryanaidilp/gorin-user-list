// ignore_for_file: one_member_abstracts

import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/exceptions/exceptions.dart';
import 'package:user_list_task/core/firebase/auth.dart';
import 'package:user_list_task/core/firebase/firestore.dart';
import 'package:user_list_task/core/firebase/storage.dart';
import 'package:user_list_task/shared/data/models/profile.dart';

abstract interface class KYCRemoteDataSource {
  Future<Profile> register({
    required String email,
    required String password,
    required String name,
    required File avatar,
  });
}

@LazySingleton(as: KYCRemoteDataSource)
class KYCRemoteDataSourceImpl implements KYCRemoteDataSource {
  final _auth = getIt<Auth>();
  final _firestore = getIt<Firestore>();
  final _storage = getIt<Storage>();

  @override
  Future<Profile> register({
    required String email,
    required String password,
    required String name,
    required File avatar,
  }) async {
    final image = await _storage.upload(avatar);

    if (image == null) {
      throw RegistrationException();
    }

    final result = await _auth.register(email, password);

    if (result == null) {
      throw RegistrationException();
    }

    final avatarUrl = await _storage.getDownloadUrl(image);

    await _firestore.setUserData(
      id: result.uid,
      email: email,
      name: name,
      avatar: avatarUrl ?? '',
    );

    final data = await _firestore.getUserData(id: result.uid);

    return Profile(
      id: result.uid,
      email: data?.email ?? '',
      name: data?.name ?? '',
      avatar: data?.avatar ?? '',
    );
  }
}
