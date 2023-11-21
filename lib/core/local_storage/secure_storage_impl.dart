import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:user_list_task/core/di/service_locator.dart';
import 'package:user_list_task/core/firebase/crashlytics.dart';
import 'package:user_list_task/core/local_storage/local_storage.dart';

@Named('secure')
@LazySingleton(as: LocalStorage)
class SecureStorageImpl implements LocalStorage {
  SecureStorageImpl(this.storage);

  final FlutterSecureStorage storage;

  @override
  Future<dynamic> get(String key) async => storage.read(key: key);

  @override
  Future<bool> remove(String key) async {
    try {
      await storage.delete(key: key);
      return true;
    } catch (e, trace) {
      await getIt<Crashlytics>().report(e, trace);
      return false;
    }
  }

  @override
  Future<bool> save(String key, dynamic value) async {
    try {
      await storage.write(key: key, value: value.toString());
      return true;
    } catch (e, trace) {
      await getIt<Crashlytics>().report(e, trace);
      return false;
    }
  }

  @override
  Future<bool> has(String key) async {
    return Future.value(storage.containsKey(key: key));
  }
}
