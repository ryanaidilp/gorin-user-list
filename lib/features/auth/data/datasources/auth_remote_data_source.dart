import 'package:injectable/injectable.dart';
import 'package:user_list_task/core/exceptions/exceptions.dart';
import 'package:user_list_task/core/firebase/auth.dart';
import 'package:user_list_task/core/firebase/firestore.dart';
import 'package:user_list_task/shared/data/models/profile.dart';

abstract interface class AuthRemoteDataSource {
  Future<Profile> login({
    required String email,
    required String password,
  });
  Future<bool> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._auth, this._firestore);

  final Auth _auth;
  final Firestore _firestore;

  @override
  Future<Profile> login({
    required String email,
    required String password,
  }) async {
    final result = await _auth.login(email, password);

    if (result == null) {
      throw AuthenticationException();
    }

    final data = await _firestore.getUserData(id: result.uid);

    if (data == null) {
      throw AuthenticationException();
    }

    return Profile(
      id: result.uid,
      email: data.email,
      name: data.name,
      avatar: data.avatar,
    );
  }

  @override
  Future<bool> logout() async {
    await _auth.logout();
    return true;
  }
}
