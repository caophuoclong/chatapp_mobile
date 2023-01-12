import 'dart:convert';

import 'package:bebes/app/modules/conversations/conversation_model.dart';
import 'package:bebes/app/modules/conversations/providers/conversation_provider.dart';
import 'package:bebes/app/services/graphql/index.dart';
import 'package:bebes/app/services/graphql/queries/index.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ConversationsController extends GetxController {
  //TODO: Implement ConversationsController
  final conversationProvider = Rxn(ConversationProvider());
  List<Conversation> conversations = RxList<Conversation>();
  final count = 0.obs;
  @override
  void onInit() {
    print("ConversationController onInit");
    super.onInit();
  }

  _getData() async {
    final grapclient = GraphAPIClient.client;
    final response = await grapclient.query(getConversations);
    List<dynamic> conversations = response["conversations"];
    for (var element in conversations) {
      conversationProvider.value!.table.insert(element);
    }
    // print("Conversations ${conversations.runtimeType}");
  }

  @override
  void onReady() async {
    // check if any conversations in database
    final conversations1 = await conversationProvider.value!.table.getAll();
    if (conversations1 == null || conversations1.isEmpty) {
      _getData();
    } else {
      if (conversationProvider.value != null) {
        conversations = await conversationProvider.value!.getConversations();
        count.value = conversations.length;
      } else {
        conversations = [];
      }
      // print("99999 ${conversations}");
    }
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
