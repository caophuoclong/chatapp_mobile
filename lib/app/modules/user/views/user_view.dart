import 'package:bebes/app/services/Sqflite/Table.dart';
import 'package:bebes/app/services/Sqflite/TableField.dart';
import 'package:bebes/app/services/Sqflite/types/filed.type.dart';
import 'package:bebes/app/services/Sqflite/types/primarykey.type.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserView extends GetView<UserController> {
  const UserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Obx(
        () => Text(
          '${controller.count.value}',
          style: TextStyle(fontSize: 20),
        ),
      )),
    );
  }
}
