import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/contact_controller.dart';

class ContactView extends GetView<ContactController> {
  const ContactView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Obx(()=> Text(
          "${controller.count}",
          style: TextStyle(fontSize: 20),
        ),)
      ),
    );
  }
}
