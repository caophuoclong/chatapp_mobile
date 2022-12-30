import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/conversations_controller.dart';

class ConversationsView extends GetView<ConversationsController> {
  ConversationsView({Key? key}) : super(key: key);
  final ConversationsController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: ListTile.divideTiles(tiles: [], color: Colors.black).toList(),
    ));
  }
}
