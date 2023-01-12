import 'dart:convert';

import 'package:bebes/app/constants/shared_key.dart';
import 'package:bebes/app/services/Sqflite/Table.dart';
import 'package:bebes/app/services/Sqflite/TableField.dart';
import 'package:bebes/app/services/Sqflite/entities/user.dart';
import 'package:bebes/app/services/Sqflite/generateField.dart';
import 'package:bebes/app/services/Sqflite/types/filed.type.dart';
import 'package:bebes/app/services/Sqflite/types/primarykey.type.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../user_model.dart';

class UserProvider extends GetConnect {
  late BebesTable<User> _userTable;
  UserProvider() : _userTable = userTable;
  BebesTable<User> get table => _userTable;
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return User.fromJson(map);
      if (map is List) return map.map((item) => User.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<dynamic> getMe() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(SharedKey.authKey) == null) return null;
    final userId = json.decode(prefs.getString(SharedKey.authKey)!)["userId"];
    print("userId $userId");
    final data = await _userTable
        .get({'_id': prefs.getString(SharedKey.authKey) != null ? userId : ""});
    return data;
  }

  Future<User?> getUser(int id) async {
    return _userTable.get({'_id': id});
  }

  Future<Response<User>> postUser(User user) async => await post('user', user);
  Future<Response> deleteUser(int id) async => await delete('user/$id');
}
