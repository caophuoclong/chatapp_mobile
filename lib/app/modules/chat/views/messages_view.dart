import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MessagesView extends GetView {
  const MessagesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'MessagesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
