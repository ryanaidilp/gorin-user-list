// ignore_for_file: one_member_abstracts

import 'package:dartz/dartz.dart';
import 'package:user_list_task/core/failures/failures.dart';
import 'package:user_list_task/shared/domain/entities/profile_entity.dart';

abstract interface class MainRepository {
  Future<Either<Failure, bool>> checkIfAuthenticated();
  Future<Either<Failure, ProfileEntity>> getUserData();
}
