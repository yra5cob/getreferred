import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';

class LocalStorageProvider {
  final storage = new FlutterSecureStorage();

  Future<String> getValue(String key) async {
    return await storage.read(key: key);
  }

  Future<void> setValue(String _key, String _value) async {
    return await storage.write(key: _key, value: _value);
  }
}
