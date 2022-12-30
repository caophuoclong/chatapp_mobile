import 'package:bebes/app/modules/contact/providers/contact_provider.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  //TODO: Implement ContactController
  final contactProvider = Rxn(ContactProvider());
  final count = 0.obs;
  @override
  void onInit() {
    print("ContactController onInit");
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
