import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:user_list_task/base/use_case.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/failures/failures.dart';
import 'package:user_list_task/shared/domain/repositories/main_repository.dart';

@LazySingleton()
class CheckIfAuthenticated implements UseCase<bool, NoParams, MainRepository> {
  @override
  Future<Either<Failure, bool>> call(NoParams param) =>
      repo.checkIfAuthenticated();

  @override
  MainRepository get repo => getIt<MainRepository>();
}
