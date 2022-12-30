import 'package:bebes/app/modules/conversations/providers/conversation_provider.dart';
import 'package:get/get.dart';

class ConversationsController extends GetxController {
  //TODO: Implement ConversationsController
  final conversationProvider = Rxn(ConversationProvider());
  final count = 0.obs;
  @override
  void onInit() {
    print("ConversationController onInit");

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

  void increment() => count.value++;
}
