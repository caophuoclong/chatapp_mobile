import 'dart:convert';

import 'package:bebes/app/modules/home/controllers/home_controller.dart';
import 'package:bebes/app/modules/login/controllers/auth_controller_controller.dart';
import 'package:bebes/app/modules/settings/controllers/settings_controller.dart';
import 'package:bebes/app/modules/user/providers/user_provider.dart';
import 'package:bebes/app/modules/user/user_model.dart';
import 'package:bebes/app/services/fetchService/index.dart';
import 'package:bebes/app/services/graphql/index.dart';
import 'package:bebes/app/services/graphql/queries/index.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserController extends GetxController with StateMixin {
  final userProvider = Rx(UserProvider());
  final HomeController hc = Get.find();
  final SettingsController sc = Get.find();
  final AuthController ac = Get.find();
  User _user = User();
  User get user => _user;
  final count = 0.obs;
  @override
  void onInit() async {
    print("UserController onInit");
    super.onInit();
  }

  @override
  void onReady() async {
    change({}, status: RxStatus.loading());
    if (hc.isInternetAccess.value) {
      final graphclient = GraphAPIClient.client;
      final response = await graphclient.query(getMeQurey);
      final data = response["getMe"];
      _user = User.fromJson(data);
    } else {
      final data = await userProvider.value.getMe();
      _user = User.fromJson(data);
    }
    change(_user, status: RxStatus.success());
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getMe1() async {
    // if (data == null) return;
    // if (data.length == 0) {
    //   final response = await fetchService.dio.get("/user");
    //   userProvider.value.table.insert(json.decode(response.toString()));
    //   return response;
    // }
    // return data;
  }

  void increment() => count.value++;
}
