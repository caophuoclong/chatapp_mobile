import 'package:bebes/app/modules/chat/bindings/chat_binding.dart';
import 'package:bebes/app/modules/chat/views/chat_view.dart';
import 'package:bebes/app/modules/contact/bindings/contact_binding.dart';
import 'package:bebes/app/modules/contact/views/contact_view.dart';
import 'package:bebes/app/modules/conversations/bindings/conversations_binding.dart';
import 'package:bebes/app/modules/conversations/views/conversations_view.dart';
import 'package:bebes/app/modules/search/bindings/search_binding.dart';
import 'package:bebes/app/modules/search/views/search_view.dart';
import 'package:bebes/app/modules/settings/bindings/settings_binding.dart';
import 'package:bebes/app/modules/settings/controllers/settings_controller.dart';
import 'package:bebes/app/modules/settings/views/settings_view.dart';
import 'package:bebes/app/modules/user/bindings/user_binding.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:bebes/app/modules/user/views/user_view.dart';
import 'package:bebes/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final SettingsController sc = Get.find();
  Widget showActions(BuildContext context) {
    int tabIndex = controller.tabIndex.value;
    switch (tabIndex) {
      case 1:
        return IconButton(
            onPressed: controller.gotoSettingsPage,
            icon: const Icon(Icons.person_add));
      case 2:
        return IconButton(
            onPressed: controller.gotoSettingsPage,
            icon: const Icon(Icons.settings));
      default:
        return IconButton(
            onPressed: controller.gotoSettingsPage,
            icon: const Icon(Icons.telegram_sharp));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: controller.goToSearchPage,
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: const [
                Icon(Icons.search),
                SizedBox(
                  width: 4,
                ),
                Text("Search something...")
              ],
            ),
          ),
        ),
        actions: [Obx(() => showActions(context))],
      ),
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: [
              Navigator(
                initialRoute: Routes.CONVERSATIONS,
                onGenerateRoute: (settings) {
                  if (settings.name == Routes.CONVERSATIONS) {
                    return GetPageRoute(
                        routeName: Routes.CONVERSATIONS,
                        page: () => ConversationsView(),
                        binding: ConversationsBinding());
                  } else if (settings.name == Routes.SEARCH) {
                    return GetPageRoute(
                        routeName: Routes.SEARCH,
                        page: () => const SearchView(),
                        binding: SearchBinding());
                  } else if (settings.name == Routes.CHAT) {
                    return GetPageRoute(
                        routeName: Routes.CHAT,
                        page: () => const ChatView(),
                        binding: ChatBinding());
                  }
                },
              ),
              Navigator(
                initialRoute: Routes.CONTACT,
                onGenerateRoute: (settings) {
                  if (settings.name == Routes.CONTACT) {
                    return GetPageRoute(
                        routeName: Routes.CONTACT,
                        page: () => const ContactView(),
                        binding: ContactBinding());
                  }
                  // else if (settings.name == Routes.USER) {
                  //   return GetPageRoute(
                  //       routeName: Routes.USER,
                  //       page: () => const UserView(),
                  //       binding: UserBinding());
                  // }
                },
              ),
              Navigator(
                initialRoute: Routes.USER,
                onGenerateRoute: (settings) {
                  if (settings.name == Routes.USER) {
                    return GetPageRoute(
                        routeName: Routes.USER,
                        page: ()=> UserView(),
                        binding: UserBinding()
                    );
                  } else if (settings.name == Routes.SETTINGS) {
                    return GetPageRoute(
                        routeName: Routes.SETTINGS,
                        page: () => const SettingsView(),
                        binding: SettingsBinding());
                  }
                },
              )
            ],
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.tabIndex.value,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.house), label: "Home"),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.solidAddressBook),
                  label: "Contact"),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.solidUser), label: "User"),
            ],
            onTap: controller.onTabClick,
          )),
    );
  }
}
