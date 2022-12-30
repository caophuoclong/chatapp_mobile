import 'package:bebes/app/routes/app_pages.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxInt tabIndex = 0.obs;
  Future goToSearchPage() async {
    await Get.toNamed(Routes.SEARCH);
  }

  Future gotoSettingsPage() async {
    await Get.toNamed(Routes.SETTINGS);
  }

  void onTabClick(int value) {
    tabIndex.value = value;
  }
}
