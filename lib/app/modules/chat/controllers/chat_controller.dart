import 'package:bebes/app/modules/chat/message_model.dart';
import 'package:bebes/app/modules/chat/providers/message_provider.dart';
import 'package:bebes/app/modules/conversations/conversation_model.dart';
import 'package:bebes/app/modules/user/user_model.dart';
import 'package:bebes/app/services/graphql/index.dart';
import 'package:bebes/app/services/graphql/queries/index.dart';
import 'package:get/get.dart';

class ChatController extends GetxController with StateMixin {
  ChatController(conversationId) {
    this.conversationId.value = conversationId;
  }
  //TODO: Implement ChatController
  final messageProvider = MessageProvider();
  final count = 0.obs;
  final message = "".obs;
  final conversationId = "".obs;
  final messages = RxList<Message>();
  @override
  void onInit() {
    print("Message controller on init");
    super.onInit();
  }

  setConversationId(String conversationId) {
    this.conversationId.value = conversationId;
  }

  @override
  void onReady() async {
    print("Message controller on ready");
    change(messages, status: RxStatus.loading());
    onInitMessage(conversationId.value);
    change(messages, status: RxStatus.success());
    super.onReady();
  }

  @override
  void onClose() {
    print("Message controller on close");
    messages.value = [];
    conversationId.value = "";
    message.value = "";
    super.onClose();
  }

  void onChange(String message) {
    this.message.value = message;
  }

  onInitMessage(String destination, {limit = 20, skip = 0}) async {
    final messages = await messageProvider.getMessages(destination,
        limit: limit, skip: skip);
    if (messages != null && messages.isNotEmpty) {
      this.messages.addAll(messages);
    } else {
      final response =
          await GraphAPIClient.client.query(getMessagesPerConversation, {
        "destination": destination,
        "take": limit,
        "skip": skip,
      });
      List messages = response["messages"];
      for (var message in messages) {
        Map<String, dynamic> xxx = {
          ...message,
          "sender": User.fromJson(message["sender"]),
          "destination": Conversation.fromJson(message["destination"]),
        };
        final newMessage = Message.fromJson(xxx);
        this.messages.add(newMessage);
      }
    }
    return "huhu";
  }

  void addMessage({value}) {
    final message = {
      "content": this.message.value,
      "type": "TEXT",
      "createdAt": DateTime.now().microsecondsSinceEpoch,
    };
    if (value != null) {
      message["content"] = value;
    }
    // print(message);
    // messages.add(message);
  }

  void increment() => count.value++;
}
