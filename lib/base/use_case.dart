import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:user_list_task/core/failures/failures.dart';

abstract class UseCase<Type, Params, Repo> {
  Repo get repo;
  Future<Either<Failure, Type>> call(Params param);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class IDParams extends Equatable {
  const IDParams({required this.id});
  final int id;

  @override
  List<Object?> get props => [id];
}

class UsingQueryParams extends Equatable {
  const UsingQueryParams({this.queryParams});
  final Map<String, dynamic>? queryParams;

  @override
  List<Object?> get props => [queryParams];
}
