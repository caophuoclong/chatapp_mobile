import 'dart:math';

import 'package:bebes/app/constants/app_theme.dart';
import 'package:bebes/app/constants/shared_key.dart';
import 'package:bebes/app/modules/chat/message_model.dart';
import 'package:bebes/app/modules/settings/controllers/settings_controller.dart';
import 'package:bebes/app/modules/user/controllers/user_controller.dart';
import 'package:bebes/app/utils/index.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/src/emoji_picker.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView {
  ChatView({Key? key}) : super(key: key);
  final args = Get.arguments;
  ScrollController _scrollController = ScrollController();
  SettingsController sc = Get.find();
  UserController uc = Get.find();
  _textMessage(String content, bool myMessage, double width, {type = "text"}) {
    return Container(
      constraints: BoxConstraints(minWidth: 20, maxWidth: width * .7),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: myMessage
              ? sc.isLightTheme.value
                  ? MyTheme.lightMyMessageBackground
                  : MyTheme.darkMyMessageBackground
              : sc.isLightTheme.value
                  ? MyTheme.lightOrderMessageBackground
                  : MyTheme.darkOrderMessageBackground,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Text(content,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: myMessage
                  ? sc.isLightTheme.value
                      ? MyTheme.lightMyMessageForeground
                      : MyTheme.darkMyMessageForeground
                  : sc.isLightTheme.value
                      ? MyTheme.lightOrderMessageForeground
                      : MyTheme.darkOrderMessageForeground)),
    );
  }

  Widget _message(Message m, double width) {
    final myId = uc.user.sId;
    final isMyMessage = m.sender!.sId == myId;
    return GestureDetector(
      child: Align(
          alignment: isMyMessage
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          child: (() {
            switch (m.type!.toLowerCase()) {
              case "image":
                return Text("message image");
              case "emoji":
                return Text("message emoji");
              case "text":
                return _textMessage(m.content!, isMyMessage, width);
              default:
                return Text("Not found type message");
            }
          })()),
    );
    // return ListTile(
    //     title: Wrap(
    //   alignment:
    //       m.sender!.sId == myId ? WrapAlignment.end : WrapAlignment.start,
    //   children: [_textMessage(content, myMessage, width)],
    // ));
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
    final visibilityKeyboard = MediaQuery.of(context).viewInsets.bottom == 0;
    final focusNode = controller.focusnode;
    print("heihgt ${MediaQuery.of(context).viewInsets.bottom}");
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
        if (controller.isSelectedEmoji.value) {
          controller.togglerSelectedEmoji();
          // focusNode.requestFocus();
        }
      },
      child: Scaffold(
          appBar: _appBar(),
          backgroundColor: sc.isLightTheme.value
              ? MyTheme.lightScreenMessage
              : MyTheme.darkPrimaryColor,
          body: controller.obx((state) {
            List<Message> messages = state;
            return Column(
              children: [
                const SizedBox(height: 25),
                Obx(
                  () => Expanded(
                      child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ),
                          controller: _scrollController,
                          reverse: true,
                          itemCount: state.length,
                          itemBuilder: (context, index) =>
                              _message(messages[index], width))),
                ),
                const SizedBox(height: 2),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                          color: sc.isLightTheme.value
                              ? MyTheme.lightOrderMessageBackground
                              : const Color.fromRGBO(61, 67, 84, 1)),
                      constraints: BoxConstraints(maxWidth: width * 0.9),
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(1.0),
                      child: Row(children: [
                        Obx(() => IconButton(
                            onPressed: () {
                              controller.togglerSelectedEmoji();
                              if (!controller.isSelectedEmoji.value) {
                                focusNode.requestFocus();
                              } else {
                                focusNode.unfocus();
                              }
                              // if (controller.isSelectedEmoji.value) {
                              // }
                            },
                            icon: !controller.isSelectedEmoji.value
                                ? const FaIcon(
                                    FontAwesomeIcons.faceSmile,
                                    size: 20,
                                  )
                                : const FaIcon(
                                    FontAwesomeIcons.solidFaceGrinWide,
                                    size: 20,
                                  ))),
                        Expanded(
                            child: TextField(
                          focusNode: focusNode,
                          keyboardType: TextInputType.text,
                          onChanged: controller.onChange,
                          controller: controller.inputController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Please enter a search term'),
                          autocorrect: false,
                          maxLines: 3,
                          minLines: 1,
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              controller.addMessage(value: value);
                              controller.inputController.clear();
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
                                      controller.inputController.clear();
                                    },
                                    icon: const FaIcon(
                                        FontAwesomeIcons.solidPaperPlane,
                                        color: MyTheme.primaryColor)),
                              )
                            : IconButton(
                                onPressed: () {},
                                icon: const FaIcon(FontAwesomeIcons.solidHeart,
                                    size: 20, color: MyTheme.primaryColor)))
                      ]),
                    ),
                    Obx(
                      () => Offstage(
                          offstage: visibilityKeyboard
                              ? !controller.isSelectedEmoji.value
                              : true,
                          child: SizedBox(
                            height: 312,
                            child: EmojiPicker(
                              onEmojiSelected: ((category, emoji) => {
                                    print("emoji ${emoji.emoji}"),
                                    controller.inputController.text =
                                        controller.inputController.text +
                                            emoji.emoji,
                                    controller.addChar(emoji.emoji)
                                  }),
                              // textEditingController: controller.inputController,
                              config: Config(
                                columns: 7,
                                emojiSizeMax: 32 *
                                    (foundation.defaultTargetPlatform ==
                                            TargetPlatform.android
                                        ? 1.30
                                        : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                                verticalSpacing: 0,
                                horizontalSpacing: 0,
                                gridPadding: EdgeInsets.zero,
                                bgColor: Color(0xFFF2F2F2),
                                indicatorColor: Colors.blue,
                                iconColor: Colors.grey,
                                iconColorSelected: Colors.blue,
                                backspaceColor: Colors.blue,
                                skinToneDialogBgColor: Colors.white,
                                skinToneIndicatorColor: Colors.grey,
                                enableSkinTones: true,
                                showRecentsTab: true,
                                recentsLimit: 28,
                                noRecents: const Text(
                                  'No Recents',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black26),
                                  textAlign: TextAlign.center,
                                ), // Needs to be const Widget
                                loadingIndicator: const SizedBox
                                    .shrink(), // Needs to be const Widget
                                tabIndicatorAnimDuration: kTabScrollDuration,
                                categoryIcons: const CategoryIcons(),
                                buttonMode: ButtonMode.MATERIAL,
                              ),
                            ),
                          )),
                    )
                  ],
                )
              ],
            );
          })),
    );
  }
}
