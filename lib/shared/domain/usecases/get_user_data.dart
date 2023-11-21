import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:user_list_task/base/use_case.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/failures/failures.dart';
import 'package:user_list_task/shared/domain/entities/profile_entity.dart';
import 'package:user_list_task/shared/domain/repositories/main_repository.dart';

@LazySingleton()
class GetUserData implements UseCase<ProfileEntity, NoParams, MainRepository> {
  @override
  Future<Either<Failure, ProfileEntity>> call(NoParams param) =>
      repo.getUserData();

  @override
  MainRepository get repo => getIt<MainRepository>();
}
