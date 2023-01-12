import 'dart:convert';

import 'package:bebes/app/constants/shared_key.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth_model.dart';

class AuthProvider extends GetConnect {
  Auth? auth;
  @override
  void onInit() async {
    // httpClient.defaultDecoder = (map) {
    //   if (map is Map<String, dynamic>) return Auth.fromJson(map);
    //   if (map is List) return map.map((item) => Auth.fromJson(item)).toList();
    // };
    // httpClient.baseUrl = 'YOUR-API-URL';
    // await getAuth();
  }

  Future<Response> deleteAuth(int id) async => await delete('auth/$id');
}
