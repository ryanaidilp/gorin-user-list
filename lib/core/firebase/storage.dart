import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class Storage {
  const Storage(this._storage);

  String get _logPrefix => 'Storage: ';

  final FirebaseStorage _storage;

  Future<String?> upload(File file) async {
    try {
      final result = await _storage
          .ref('images/${file.path.split('/').last}')
          .putFile(file);
      return result.metadata?.name;
    } catch (e) {
      log('$_logPrefix$e');
      return null;
    }
  }

  Future<String?> getDownloadUrl(String fileName) async {
    try {
      final result = _storage.ref('images/$fileName');
      return result.getDownloadURL();
    } catch (e) {
      log('$_logPrefix$e');
      return null;
    }
  }
}
