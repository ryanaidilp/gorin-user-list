import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:user_list_task/core/failures/failures.dart';
import 'package:user_list_task/shared/data/datasources/main_local_data_source.dart';
import 'package:user_list_task/shared/domain/entities/profile_entity.dart';
import 'package:user_list_task/shared/domain/repositories/main_repository.dart';

@LazySingleton(as: MainRepository)
class MainRepositoryImpl implements MainRepository {
  const MainRepositoryImpl(this._localDataSource);

  final MainLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, bool>> checkIfAuthenticated() async {
    try {
      final result = await _localDataSource.checkIfAuthenticated();
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> getUserData() async {
    try {
      final result = await _localDataSource.getUserData();
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }
}
