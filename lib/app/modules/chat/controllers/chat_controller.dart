import 'package:bebes/app/modules/chat/providers/message_provider.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  //TODO: Implement ChatController
  final messageProvider = Rxn(MessageProvider());
  final count = 0.obs;
  final message = "".obs;
  final List<Map<String, dynamic>> messages = RxList();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onChange(String message) {
    this.message.value = message;
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
    messages.add(message);
  }

  void increment() => count.value++;
}
