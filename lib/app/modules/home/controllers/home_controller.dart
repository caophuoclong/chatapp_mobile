import 'package:bebes/app/modules/settings/controllers/settings_controller.dart';
import 'package:bebes/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxInt tabIndex = 0.obs;
  RxBool isInternetAccess = true.obs;

  SettingsController sc = Get.find();

  @override
  void onInit() async {
    final connectivity = (await Connectivity().checkConnectivity());
    if (connectivity == ConnectivityResult.none) isInternetAccess.value = false;
    Connectivity().onConnectivityChanged.listen((event) {
      if (event != ConnectivityResult.none) {
        isInternetAccess.value = true;
      } else {
        isInternetAccess.value = false;
      }
    });
    super.onInit();
  }

  Future goToSearchPage() async {
    await Get.toNamed(Routes.SEARCH);
  }

  Future gotoSettingsPage() async {
    await Get.toNamed(Routes.SETTINGS);
  }

  changeTheme() {
    sc.changeTheme(!sc.isLightTheme.value);
  }

  void onTabClick(int value) {
    tabIndex.value = value;
  }

  void onSwipeLeft(dynamic value) {
    if (tabIndex.value < 2) {
      tabIndex.value++;
    }
    print("left ${tabIndex.value}");
  }

  void onSwipeRight(dynamic value) {
    if (tabIndex.value > 0) {
      tabIndex.value--;
    }
    print("right ${tabIndex.value}");
  }
}
