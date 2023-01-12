import 'dart:convert';

import 'package:bebes/app/config/index.dart';
import 'package:bebes/app/constants/app_theme.dart';
import 'package:bebes/app/modules/home/controllers/home_controller.dart';
import 'package:bebes/app/modules/login/controllers/auth_controller_controller.dart';
import 'package:bebes/app/modules/settings/controllers/settings_controller.dart';
import 'package:bebes/app/modules/user/user_model.dart';
import 'package:bebes/app/services/Sqflite/Table.dart';
import 'package:bebes/app/services/Sqflite/TableField.dart';
import 'package:bebes/app/services/Sqflite/types/filed.type.dart';
import 'package:bebes/app/services/Sqflite/types/primarykey.type.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserView extends GetView<UserController> {
  UserView({Key? key}) : super(key: key);
  _userInfo(String avatarUrl, String name, String email) {
    return Center(
        child: Column(children: [
      CircleAvatar(
          radius: 50,
          backgroundImage:
              NetworkImage(ConfigService.renderServerImageUrl(avatarUrl))),
      const SizedBox(height: 10),
      Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
      const SizedBox(height: 10),
      Text(
        email,
        style: const TextStyle(color: Colors.grey),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)))),
        child: Row(mainAxisSize: MainAxisSize.min, children: const [
          Text("Edit profile"),
          SizedBox(width: 10),
          FaIcon(FontAwesomeIcons.pen)
        ]),
        onPressed: () {},
      )
    ]));
  }

  _settings(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  FaIcon(FontAwesomeIcons.globe),
                  SizedBox(width: 10),
                  Text("Language"),
                ],
              ),
              const Text("EN")
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  FaIcon(FontAwesomeIcons.solidSun),
                  SizedBox(width: 10),
                  Text("Light Mode"),
                ],
              ),
              Obx(() => Switch(
                    onChanged: (value) {
                      controller.sc.changeTheme(value);
                    },
                    value: controller.sc.isLightTheme.value,
                  ))
            ],
          ),
          GestureDetector(
              onTap: () {
                controller.ac.logOut();
                controller.hc.onTabClick(0);
              },
              child: Row(
                children: const [
                  Icon(Icons.logout),
                  SizedBox(width: 10),
                  Text("Log out"),
                ],
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return controller.obx(((state) {
      final user = state.toJson();
      return Scaffold(
          body: Column(
        children: [
          _userInfo(user["avatarUrl"], user["name"], user["email"]),
          const SizedBox(
            height: 10,
          ),
          Obx(
            () => Container(
                color: !controller.sc.isLightTheme.value
                    ? MyTheme.darkSecondaryColor
                    : MyTheme.lightSecondaryColor,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Settings",
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          _settings(context)
        ],
      ));
    }));
  }
}
