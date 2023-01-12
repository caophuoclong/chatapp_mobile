import 'dart:convert';

import 'package:bebes/app/config/env.dart';
import 'package:bebes/app/constants/app_theme.dart';
import 'package:bebes/app/constants/shared_key.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  await initHiveForFlutter();
  runApp(
    GetMaterialApp(
      title: "Bebe's Chat",
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    ),
  );
}
