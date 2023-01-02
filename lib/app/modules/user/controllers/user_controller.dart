import 'package:bebes/app/modules/user/providers/user_provider.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  //TODO: Implement UserController
  final userProvider = UserProvider();
  final count = 0.obs;
  @override
  void onInit() {
    print("UserController onInit");
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
