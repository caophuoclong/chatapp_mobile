import 'package:bebes/app/modules/home/controllers/home_controller.dart';
import 'package:bebes/app/modules/settings/controllers/settings_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeThemeView extends GetView<SettingsController> {
  ChangeThemeView({Key? key}) : super(key: key) {
    // _getThemeStatus();
  }

  // _getThemeStatus() async {
  //   var _isLight = _prefs.then((SharedPreferences prefs) {
  //     return prefs.getBool("theme") != null ? prefs.getBool("theme") : true;
  //   }).obs;
  //   controller.changeTheme(await _isLight.value == null ? false : true);
  //   Get.changeThemeMode(
  //       controller.isLightTheme.value ? ThemeMode.light : ThemeMode.dark);
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (builder) {
              return Container(
                decoration: BoxDecoration(
                    color: controller.isLightTheme.value
                        ? Colors.white
                        : Colors.blueGrey,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                height: 250,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => GestureDetector(
                              onTap: () => {controller.changeTheme(true)},
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        10), // Image border
                                    child: SizedBox(
                                      width: 100,
                                      height: 120,
                                      child: Image.network(
                                          "https://picsum.photos/300",
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Text("Light Mode"),
                                      Checkbox(
                                          value: controller.isLightTheme.value,
                                          onChanged: (value) =>
                                              {controller.changeTheme(true)})
                                    ],
                                  )
                                ],
                              ))),
                          const SizedBox(width: 40),
                          Obx(() => GestureDetector(
                              onTap: () => {controller.changeTheme(false)},
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        10), // Image border
                                    child: SizedBox(
                                      width: 100,
                                      height: 120,
                                      child: Image.network(
                                          "https://picsum.photos/300",
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Text("Dark mode"),
                                      Checkbox(
                                        value: !controller.isLightTheme.value,
                                        onChanged: (value) =>
                                            {controller.changeTheme(false)},
                                      )
                                    ],
                                  )
                                ],
                              ))),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      },
      child: const ListTile(
          leading: Icon(Icons.dark_mode), title: Text("Change theme")),
    );
  }
}
