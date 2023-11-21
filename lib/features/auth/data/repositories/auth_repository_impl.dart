import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:user_list_task/core/failures/failures.dart';
import 'package:user_list_task/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:user_list_task/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:user_list_task/features/auth/domain/repositories/auth_repository.dart';
import 'package:user_list_task/shared/domain/entities/profile_entity.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, ProfileEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      final stored = await _localDataSource.storeUserData(result);

      if (!stored) {
        return Left(DatabaseFailure());
      }

      return Right(result);
    } catch (e) {
      return Left(AuthenticationFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _remoteDataSource.logout();

      if (!result) {
        return Left(LogoutFailure());
      }

      final deleted = await _localDataSource.deleteUserData();

      return Right(deleted);
    } catch (e) {
      return Left(LogoutFailure());
    }
  }
}
