import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:user_list_task/shared/data/models/profile.dart';

@LazySingleton()
class Firestore {
  const Firestore(this._firestore);

  String get _logPrefix => 'Firestore: ';

  final FirebaseFirestore _firestore;

  Stream<QuerySnapshot> getAllUsers() =>
      _firestore.collection('users').snapshots(
            includeMetadataChanges: true,
          );

  Future<bool> setUserData({
    required String id,
    required String email,
    required String name,
    required String avatar,
  }) async {
    try {
      await _firestore.collection('users').doc(id).set({
        'email': email,
        'name': name,
        'avatar': avatar,
      });
      return true;
    } catch (e) {
      log('$_logPrefix$e');
      return false;
    }
  }

  Future<Profile?> getUserData({
    required String id,
  }) async {
    try {
      final result = await _firestore
          .collection('users')
          .doc(id)
          .withConverter(
            fromFirestore: Profile.fromFirestore,
            toFirestore: (Profile profile, _) => profile.toJson(),
          )
          .get();
      return result.data();
    } catch (e) {
      log('$_logPrefix$e');
      return null;
    }
  }

  Future<bool> updateUserData({
    required String email,
    String? name,
    String? avatar,
  }) async {
    try {
      final data = {
        if (name != null) ...{
          'name': name,
        },
        if (avatar != null) ...{
          'avatar': avatar,
        },
      };

      if (data.isEmpty) {
        return false;
      }

      final user = _firestore.collection('users').doc(email);
      await user.update(data);
      return true;
    } catch (e) {
      log('$_logPrefix$e');
      return false;
    }
  }
}
