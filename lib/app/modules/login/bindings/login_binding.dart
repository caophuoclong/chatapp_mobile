import 'package:get/get.dart';

import 'package:bebes/app/modules/login/controllers/auth_controller_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
  }
}
