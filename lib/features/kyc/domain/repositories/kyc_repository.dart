// ignore_for_file: one_member_abstracts

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:user_list_task/core/failures/failures.dart';
import 'package:user_list_task/shared/domain/entities/profile_entity.dart';

abstract interface class KYCRepository {
  Future<Either<Failure, ProfileEntity>> register({
    required String email,
    required String password,
    required String name,
    required File avatar,
  });
}
