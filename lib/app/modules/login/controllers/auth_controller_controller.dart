import 'dart:convert';
import 'dart:io';
import 'package:bebes/app/config/env.dart';
import 'package:bebes/app/services/Sqflite/Table.dart';
import 'package:bebes/app/services/auth/index.dart';
import 'package:bebes/app/services/fetchService/index.dart';
import 'package:bebes/app/services/Sqflite/generateField.dart';
import 'package:bebes/app/services/fetchService/bebes.interceptor.dart';
import 'package:bebes/app/services/Sqflite/types/filed.type.dart';
import 'package:bebes/app/services/Sqflite/types/primarykey.type.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:http/http.dart' as http;

import 'package:bebes/app/constants/shared_key.dart';
import 'package:bebes/app/modules/home/controllers/home_controller.dart';
import 'package:bebes/app/modules/login/providers/auth_provider.dart';
import "package:bebes/app/modules/login/auth_model.dart";
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final hc = Get.find<HomeController>();
  Auth? auth;
  final fetchService = FetchService();
  final AuthService _authService = AuthService();
  BebesTable table = BebesTable(
      "auth",
      "userId",
      PrimaryKeyType.uuid,
      GenerateField.generate({
        "refreshToken": {
          "type": FieldType.string,
          "notNull": true,
          "isUnique": true
        }
      }));
  final count = 0.obs;
  final isAuthenticated = false.obs;
  @override
  Future onInit() async {
    await fetchService.initial();
    super.onInit();
  }

  Future autoLogin() async {
    try {
      print("Authlogin");
      final data = await _authService.getAuth();
      if (data == null) {
        return isAuthenticated.value = false;
      }
      return isAuthenticated.value = true;
    } catch (_) {
      print(_);
    }
    // print(_authProvider.value.auth!.toJson());
  }

  bool get isAuthencated => auth != null && auth!.token != null;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<String?> login(dynamic data) async {
    try {
      final response = await fetchService.dio.post('/auth/login',
          data: {"username": data.name, "password": data.password});
      switch (response.statusCode) {
        case 201:
          final refreshToken =
              response.headers["set-cookie"]?[0].split(";")[0].split("=")[1];
          final isExist = await table.get({"userId": response.data["userId"]},
              select: "refreshToken", relations: null);
          print("is exist $isExist");
          if (isExist == null) {
            await table.insert({
              "userId": response.data["userId"],
              "refreshToken": refreshToken
            });
          } else {
            await table.update({
              "userId": response.data["userId"],
              "refreshToken": refreshToken
            });
          }
          _authService.saveAuth(response.data);
          isAuthenticated.value = true;
          break;
        case 403:
          return "Password doesnot match";
        default:
          print("statusCode ${response.statusCode}");
          // print("body ${response.body}");
          return "Something worng";
      }
    } on HttpException catch (_) {
      print(_);
      return "Offline";
    }
  }

  logOut() async {
    await _authService.logOut();
    isAuthenticated.value = false;
    hc.onTabClick(0);
  }

  void increment() => count.value++;
}
