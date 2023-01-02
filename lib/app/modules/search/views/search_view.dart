import 'package:bebes/app/constants/app_theme.dart';
import 'package:bebes/app/modules/settings/controllers/settings_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  SearchView({Key? key}) : super(key: key);
  final SettingsController sc = Get.find();
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
        title: const Text('SearchView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'SearchView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
