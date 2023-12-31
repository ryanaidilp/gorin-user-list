import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:user_list_task/core/exceptions/exceptions.dart';
import 'package:user_list_task/shared/domain/entities/profile_entity.dart';

@LazySingleton()
class Auth {
  const Auth(this._auth);

  String get _logPrefix => 'Auth: ';

  final FirebaseAuth _auth;

  Future<ProfileEntity?> getCurrentUser() async {
    ProfileEntity? data;

    try {
      final user = _auth.currentUser;

      if (user != null) {
        data = ProfileEntity(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
          avatar: user.photoURL ?? '',
        );
      }
    } catch (e) {
      log('$_logPrefix$e');
    }

    return data;
  }

  Future<User?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code.contains('user-not-found')) {
        throw UserNotFoundException();
      }
      throw AuthenticationException();
    } catch (e) {
      throw AuthenticationException();
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code.contains('email-already-in-use')) {
        throw DuplicateAccountException();
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() => _auth.signOut();
}
