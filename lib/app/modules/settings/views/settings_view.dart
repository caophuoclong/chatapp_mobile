import 'package:bebes/app/modules/settings/views/change_theme_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings view'),
      ),
      body: ListView(
        children: ListTile.divideTiles(context: context, tiles: [
          ChangeThemeView(),
          GestureDetector(
            child: const ListTile(
                leading: Icon(Icons.dark_mode), title: Text("Change theme")),
          )
        ]).toList(),
      ),
    );
  }
}
