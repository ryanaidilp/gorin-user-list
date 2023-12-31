import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:user_list_task/base/use_case.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/failures/failures.dart';
import 'package:user_list_task/features/kyc/domain/repositories/kyc_repository.dart';
import 'package:user_list_task/shared/domain/entities/profile_entity.dart';

@LazySingleton()
class Register implements UseCase<ProfileEntity, RegisterParam, KYCRepository> {
  @override
  Future<Either<Failure, ProfileEntity>> call(RegisterParam param) =>
      repo.register(
        email: param.email,
        password: param.password,
        name: param.name,
        avatar: param.avatar,
      );

  @override
  KYCRepository get repo => getIt<KYCRepository>();
}

class RegisterParam extends Equatable {
  const RegisterParam({
    required this.email,
    required this.password,
    required this.name,
    required this.avatar,
  });
  final String email;
  final String password;
  final String name;
  final File avatar;
  @override
  List<Object> get props => [email, password, name, avatar];
}
