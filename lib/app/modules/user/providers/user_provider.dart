import 'package:bebes/app/services/Sqflite/Table.dart';
import 'package:bebes/app/services/Sqflite/TableField.dart';
import 'package:bebes/app/services/Sqflite/types/filed.type.dart';
import 'package:bebes/app/services/Sqflite/types/primarykey.type.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../user_model.dart';

class UserProvider extends GetConnect {
  late BebesTable<User> _userTable;
  UserProvider()
      : _userTable = BebesTable(
          "user",
          '_id',
          PrimaryKeyType.uuid,
          [
            Field('name', FieldType.string, ''),
            Field('email', FieldType.string, ''),
            Field('password', FieldType.string, ''),
            Field('phone', FieldType.string, ''),
            Field("username", FieldType.string, ''),
            Field("gender", FieldType.string, ''),
            Field("birthday", FieldType.string, ''),
            Field("active", FieldType.boolean, false),
            Field("created_at", FieldType.datetime, DateTime.now().toString()),
            Field("updated_at", FieldType.datetime, DateTime.now().toString()),
            Field("avtarUrl", FieldType.string, ''),
          ],
        );
  BebesTable<User> get table => _userTable;
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return User.fromJson(map);
      if (map is List) return map.map((item) => User.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<User> getMe() async {
    final prefs = await SharedPreferences.getInstance();
    return _userTable.get({'_id': prefs.getString('user_id')});
  }

  Future<User?> getUser(int id) async {
    return _userTable.get({'_id': id});
  }

  Future<Response<User>> postUser(User user) async => await post('user', user);
  Future<Response> deleteUser(int id) async => await delete('user/$id');
}
