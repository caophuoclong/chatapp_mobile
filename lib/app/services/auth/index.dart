import 'dart:convert';

import 'package:bebes/app/constants/shared_key.dart';
import 'package:bebes/app/modules/login/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  late Auth auth;
  final Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();
  Future<Auth?> getAuth() async {
    String? authKey = (await _sharedPreferences).getString(SharedKey.authKey);
    // await saveAuth(Auth.fromJson({'userId': 'long', 'token': '11skkdkfjsjs'}));
    if (authKey != null) {
      auth = Auth.fromJson(json.decode(authKey));
      return auth;
    } else {
      return null;
    }
  }

  Future<void> saveAuth(Map<String, dynamic> objectToken) async {
    await (await _sharedPreferences)
        .setString(SharedKey.authKey, json.encode(objectToken));
  }

  Future<bool> isExist(dynamic key) async {
    return (await _sharedPreferences).containsKey(key);
  }

  Future<void> logOut() async {
    (await _sharedPreferences).remove(SharedKey.authKey);
  }
}
