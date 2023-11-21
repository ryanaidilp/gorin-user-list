import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:user_list_task/core/failures/failures.dart';
import 'package:user_list_task/shared/data/datasources/main_remote_data_source.dart';
import 'package:user_list_task/shared/domain/repositories/main_repository.dart';

@LazySingleton(as: MainRepository)
class MainRepositoryImpl implements MainRepository {
  const MainRepositoryImpl(this._remoteDataSource);

  final MainRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, bool>> checkIfAuthenticated() async {
    try {
      final result = await _remoteDataSource.checkIfAuthenticated();
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }
}
