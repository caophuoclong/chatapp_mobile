import 'package:bebes/app/config/index.dart';
import 'package:bebes/app/constants/app_theme.dart';
import 'package:bebes/app/modules/home/controllers/home_controller.dart';
import 'package:bebes/app/modules/login/controllers/auth_controller_controller.dart';
import 'package:bebes/app/modules/settings/controllers/settings_controller.dart';
import 'package:bebes/app/routes/app_pages.dart';
import 'package:bebes/app/utils/index.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/conversations_controller.dart';

class ConversationsView extends GetView<ConversationsController> {
  ConversationsView({Key? key}) : super(key: key);
  final SettingsController sc = Get.find();
  final recent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: const Text("RECENT",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                  letterSpacing: 10)),
        ),
        Container(
          height: 120,
          padding: const EdgeInsets.all(15.0),
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 30,
              itemBuilder: (context, index) => Column(
                    children: [
                      Stack(
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                NetworkImage("https://picsum.photos/200"),
                            radius: 30,
                          ),
                          Positioned(
                              bottom: 1,
                              right: 5,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(1000))),
                                width: 10,
                                height: 10,
                              ))
                        ],
                      ),
                      const Text("chaof",
                          style: TextStyle(fontWeight: FontWeight.w900))
                    ],
                  ),
              separatorBuilder: (context, index) => const SizedBox(
                    width: 10,
                  )),
        ),
      ]);
  conversations() {
    return Expanded(
        child: Obx(() => Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: sc.isLightTheme.value
                    ? MyTheme.lightSecondaryColor
                    : MyTheme.darkSecondaryColor,
              ),
              child: Obx(() => ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: controller.count.value,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  itemBuilder: (context, index) {
                    // print("tictactoe ${controller.conversations[index]}");
                    final conversation =
                        controller.conversations[index].toJson();
                    return ListTile(
                      onTap: () =>
                          Get.toNamed(Routes.CHAT, arguments: conversation),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Utils.customCircleImage(conversation["avatarUrl"]),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(conversation["name"],
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900)),
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("You: message",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: sc.isLightTheme.value
                                                ? MyTheme.lightTextSecond
                                                : MyTheme.darkTextSecond)),
                                    Text("Time",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: sc.isLightTheme.value
                                                ? MyTheme.lightTextSecond
                                                : MyTheme.darkTextSecond)),
                                  ],
                                ),
                              )
                            ],
                          ))
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ))),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [recent, conversations()]));
  }
}
