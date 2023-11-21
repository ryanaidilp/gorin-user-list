import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:user_list_task/core/failures/failures.dart';
import 'package:user_list_task/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:user_list_task/features/kyc/data/datasources/kyc_remote_data_source.dart';
import 'package:user_list_task/features/kyc/domain/repositories/kyc_repository.dart';
import 'package:user_list_task/shared/domain/entities/profile_entity.dart';

@LazySingleton(as: KYCRepository)
class KYCRepositoryImpl implements KYCRepository {
  const KYCRepositoryImpl(
    this._remoteDataSource,
    this._authLocalDataSource,
  );

  final KYCRemoteDataSource _remoteDataSource;

  final AuthLocalDataSource _authLocalDataSource;

  @override
  Future<Either<Failure, ProfileEntity>> register({
    required String email,
    required String password,
    required String name,
    required File avatar,
  }) async {
    try {
      final result = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
        avatar: avatar,
      );

      final isSaved = await _authLocalDataSource.storeUserData(result);

      if (!isSaved) {
        return Left(RegistrationFailure());
      }

      return Right(result);
    } catch (e) {
      return Left(RegistrationFailure());
    }
  }
}
