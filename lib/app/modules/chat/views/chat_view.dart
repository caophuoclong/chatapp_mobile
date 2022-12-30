import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'ChatView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}