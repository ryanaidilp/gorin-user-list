import 'package:dartz/dartz.dart';
import 'package:user_list_task/core/failures/failures.dart';
import 'package:user_list_task/shared/domain/entities/profile_entity.dart';

abstract interface class KYCRepository {
  Future<Either<Failure, ProfileEntity>> register({
    required String email,
    required String name,
    required String avatar,
  });
}
