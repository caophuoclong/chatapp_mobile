import 'package:bebes/app/modules/home/controllers/home_controller.dart';
import 'package:bebes/app/modules/login/controllers/auth_controller_controller.dart';
import 'package:bebes/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

const users = {
  "caophuoclong": "xinchaolonglong",
  "caophuoclong.se": "xinchaophuoclong"
};

class LoginView extends GetView<AuthController> {
  LoginView({Key? key}) : super(key: key);
  HomeController hc = Get.find<HomeController>();
  Future<String?> _authUser(LoginData data) async {
    if (hc.isInternetAccess.value) {
      return controller.login(data);
    } else {
      return "No internet access";
    }
    // return Future.delayed(const Duration(milliseconds: 1500)).then((_) {
    //   if (users.containsKey(data.name) && users[data.name] == data.password) {
    //     controller.login(data);
    //     return null;
    //   } else {
    //     return "Something wrong";
    //   }
    // });
  }

  Future<String?> _recoverPassword(String value) async {}
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
        title: "Bebe's",
        onSignup: (_) {},
        userType: LoginUserType.name,
        userValidator: ((value) {
          print(value);
        }),
        theme: LoginTheme(
            titleStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                fontFamily: 'Quicksand',
                letterSpacing: 4,
                fontStyle: FontStyle.italic)),
        logo: const AssetImage("assets/images/logo.png"),
        onLogin: _authUser,
        onSubmitAnimationCompleted: () {
          Get.toNamed(Routes.HOME);
        },
        messages: LoginMessages(userHint: "Username"),
        onRecoverPassword: _recoverPassword);
  }
}
