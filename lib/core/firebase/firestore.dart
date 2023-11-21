import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class Firestore {
  const Firestore(this._firestore);

  String get _logPrefix => 'Firestore: ';

  final FirebaseFirestore _firestore;

  Stream<dynamic> getAllUsers() => _firestore.collection('users').snapshots(
        includeMetadataChanges: true,
      );

  Future<bool> setUserData({
    required String email,
    required String name,
    required String avatar,
  }) async {
    try {
      await _firestore.collection('users').doc(email).set({
        'name': name,
        'avatar': avatar,
      });
      return true;
    } catch (e) {
      return false;
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
      return false;
    }
  }
}
