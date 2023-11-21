import 'package:dartz/dartz.dart';
import 'package:user_list_task/core/failures/failures.dart';
import 'package:user_list_task/shared/domain/entities/profile_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, ProfileEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, bool>> logout();
}
