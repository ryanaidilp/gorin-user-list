// ignore_for_file: one_member_abstracts

import 'package:dartz/dartz.dart';
import 'package:user_list_task/core/failures/failures.dart';

abstract interface class MainRepository {
  Future<Either<Failure, bool>> checkIfAuthenticated();
}
