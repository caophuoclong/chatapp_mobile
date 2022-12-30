import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  //TODO: Implement SettingsController

  RxBool isLightTheme = false.obs;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  _saveThemeStatus(bool value) async {
    SharedPreferences pref = await _prefs;
    pref.setBool("theme", value);
  }

  @override
  void onInit() {
    super.onInit();
    _getThemeStatus();
  }

  _getThemeStatus() async {
    var isLight = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool("theme") ?? true;
    }).obs;
    var value = await isLight.value;
    isLightTheme.value = value;
    Get.changeThemeMode(value ? ThemeMode.light : ThemeMode.dark);
  }

  changeTheme(bool value) {
    isLightTheme.value = value;
    Get.changeThemeMode(value ? ThemeMode.light : ThemeMode.dark);
    _saveThemeStatus(value);
  }
}
