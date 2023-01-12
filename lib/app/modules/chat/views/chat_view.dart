import 'dart:math';

import 'package:bebes/app/constants/app_theme.dart';
import 'package:bebes/app/constants/shared_key.dart';
import 'package:bebes/app/modules/chat/message_model.dart';
import 'package:bebes/app/modules/settings/controllers/settings_controller.dart';
import 'package:bebes/app/modules/user/controllers/user_controller.dart';
import 'package:bebes/app/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView {
  ChatView({Key? key}) : super(key: key);
  final args = Get.arguments;
  ScrollController _scrollController = ScrollController();
  SettingsController sc = Get.find();
  UserController uc = Get.find();
  Future<Widget> _message(Message m, double width) async {
    final myId = uc.user.sId;
    if (m.sender!.sId == myId) {
      return ListTile(
        // trailing: Utils.customCircleImage(m.sender!.avatarUrl ?? "nothing",
        //     radius: 18),
        title: Wrap(
          alignment: WrapAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(minWidth: 20, maxWidth: width * .7),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: sc.isLightTheme.value
                      ? MyTheme.lightMyMessageBackground
                      : MyTheme.darkMyMessageBackground,
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Text(m.content!,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: sc.isLightTheme.value
                          ? MyTheme.lightMyMessageForeground
                          : MyTheme.darkMyMessageForeground)),
            ),
          ],
        ),
      );
    } else {
      return ListTile(
        // trailing: Utils.customCircleImage(m.sender!.avatarUrl ?? "nothing",
        //     radius: 18),
        title: Wrap(
          children: [
            Container(
              constraints: BoxConstraints(minWidth: 20, maxWidth: width * .7),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: sc.isLightTheme.value
                      ? MyTheme.lightOrderMessageBackground
                      : MyTheme.darkOrderMessageBackground,
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Text(m.content!,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: sc.isLightTheme.value
                          ? MyTheme.lightOrderMessageForeground
                          : MyTheme.darkOrderMessageForeground)),
            ),
          ],
        ),
      );
    }
  }

  _appBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      // shape: Border(
      //     bottom: BorderSide(
      //         color: MyTheme.getAppBarColor(
      //             sc.isLightTheme.value)["foregroundColor"],
      //         width: .3)),
      backgroundColor:
          MyTheme.getAppBarColor(sc.isLightTheme.value)["backgroundColor"],
      shadowColor: MyTheme.getAppBarColor(sc.isLightTheme.value)["shadowColor"],
      foregroundColor:
          MyTheme.getAppBarColor(sc.isLightTheme.value)["foregroundColor"],
      title: Row(children: [
        Utils.customCircleImage(args["avatarUrl"], radius: 20),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              args["name"],
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: MyTheme.getAppBarColor(
                      sc.isLightTheme.value)["foregroundColor"],
                  fontSize: 16),
            ),
            // Row(
            //   children: [
            //     const Icon(
            //       Icons.circle,
            //       size: 10,
            //       color: Colors.green,
            //     ),
            //     const SizedBox(width: 5),
            //     Text(
            //       "Active now",
            //       style: TextStyle(
            //           fontWeight: FontWeight.w400,
            //           color: MyTheme.getAppBarColor(
            //               sc.isLightTheme.value)["foregroundColor"],
            //           fontSize: 12),
            //     ),
            //   ],
            // )
          ],
        )
      ]),
      actions: [
        IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.phone,
                size: 20, color: MyTheme.primaryColor)),
        IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.video,
                size: 20, color: MyTheme.primaryColor)),
        IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.circleInfo,
                size: 20, color: MyTheme.primaryColor)),
      ],
    );
  }

  _scrollToBottom() {
    _scrollController.animateTo(0.0,
        duration: const Duration(microseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController(args["_id"]));

    final width = MediaQuery.of(context).size.width;
    final TextEditingController _messageInputController =
        TextEditingController();
    final focusNode = FocusNode();
    return Scaffold(
        appBar: _appBar(),
        backgroundColor: sc.isLightTheme.value
            ? MyTheme.lightScreenMessage
            : MyTheme.darkPrimaryColor,
        body: controller.obx((state) {
          List<Message> messages = state;
          return GestureDetector(
            onTap: () {
              focusNode.unfocus();
            },
            child: Column(
              children: [
                const SizedBox(height: 25),
                Obx(
                  () => Expanded(
                      child: ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          itemCount: state.length,
                          itemBuilder: (context, index) => FutureBuilder(
                              future: _message(messages[index], width),
                              builder: (context, snapshot) {
                                return snapshot.data ?? Text("Asdf");
                              }))),
                ),
                const SizedBox(height: 2),
                Container(
                    decoration: BoxDecoration(
                        // border: Border(
                        //     top: BorderSide(
                        //         width: .3,
                        //         color: MyTheme.getAppBarColor(sc
                        //             .isLightTheme.value)["foregroundColor"]))
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        color: sc.isLightTheme.value
                            ? MyTheme.lightOrderMessageBackground
                            : const Color.fromRGBO(61, 67, 84, 1)),
                    constraints: BoxConstraints(maxWidth: width * 0.9),
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(1.0),
                    child: Row(children: [
                      IconButton(
                          onPressed: () {},
                          icon: const FaIcon(
                            FontAwesomeIcons.faceSmile,
                            size: 20,
                          )),
                      Expanded(
                          child: TextField(
                        focusNode: focusNode,
                        keyboardType: TextInputType.text,
                        onChanged: controller.onChange,
                        controller: _messageInputController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Please enter a search term'),
                        autocorrect: false,
                        maxLines: 3,
                        minLines: 1,
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            controller.addMessage(value: value);
                            _messageInputController.clear();
                            focusNode.requestFocus();
                          }
                        },
                      )),
                      Obx(() => controller.message.value.isNotEmpty
                          ? Transform.rotate(
                              angle: 0 * pi / 100,
                              child: IconButton(
                                  onPressed: () {
                                    controller.addMessage();
                                    _messageInputController.clear();
                                  },
                                  icon: const FaIcon(
                                      FontAwesomeIcons.solidPaperPlane,
                                      color: MyTheme.primaryColor)),
                            )
                          : IconButton(
                              onPressed: () {},
                              icon: const FaIcon(FontAwesomeIcons.solidHeart,
                                  size: 20, color: MyTheme.primaryColor)))
                    ]))
              ],
            ),
          );
        }));
  }
}
