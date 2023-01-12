import 'package:bebes/app/constants/app_theme.dart';
import 'package:bebes/app/modules/login/controllers/auth_controller_controller.dart';
import 'package:bebes/app/modules/settings/views/change_theme_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  SettingsView({Key? key}) : super(key: key);
  final SettingsController sc = Get.find();
  final AuthController ac = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            MyTheme.getAppBarColor(sc.isLightTheme.value)["backgroundColor"],
        shadowColor:
            MyTheme.getAppBarColor(sc.isLightTheme.value)["shadowColor"],
        foregroundColor:
            MyTheme.getAppBarColor(sc.isLightTheme.value)["foregroundColor"],
        title: const Text('Settings view'),
      ),
      body: ListView(
        children: ListTile.divideTiles(context: context, tiles: [
          ChangeThemeView(),
          ListTile(
              onTap: () {
                ac.logOut();
                Navigator.pop(context);
              },
              leading: const Icon(Icons.logout),
              title: const Text("Logout"))
        ]).toList(),
      ),
    );
  }
}
