import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:user_list_task/base/use_case.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/failures/failures.dart';
import 'package:user_list_task/features/auth/domain/repositories/auth_repository.dart';
import 'package:user_list_task/shared/domain/entities/profile_entity.dart';

@LazySingleton()
class Login implements UseCase<ProfileEntity, LoginParam, AuthRepository> {
  @override
  Future<Either<Failure, ProfileEntity>> call(LoginParam param) => repo.login(
        email: param.email,
        password: param.password,
      );

  @override
  AuthRepository get repo => getIt<AuthRepository>();
}

class LoginParam extends Equatable {
  const LoginParam({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
