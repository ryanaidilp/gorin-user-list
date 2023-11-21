import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:user_list_task/base/use_case.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/failures/failures.dart';
import 'package:user_list_task/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton()
class Logout implements UseCase<bool, NoParams, AuthRepository> {
  @override
  Future<Either<Failure, bool>> call(NoParams param) => repo.logout();

  @override
  AuthRepository get repo => getIt<AuthRepository>();
}
