import 'package:bebes/app/constants/app_theme.dart';
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
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:bebes/app/modules/user/views/user_view.dart';
import 'package:bebes/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final SettingsController sc = Get.find();

  List<Widget> showActions(BuildContext context) {
    final tabIndex = controller.tabIndex.value;
    switch (tabIndex) {
      case 1:
        return [
          IconButton(
              onPressed: controller.gotoSettingsPage,
              icon: const Icon(Icons.person_add))
        ];
      case 2:
        return [
          IconButton(
              onPressed: controller.gotoSettingsPage,
              icon: const Icon(Icons.settings))
        ];
      default:
        return [
          IconButton(
              onPressed: controller.changeTheme,
              icon: sc.isLightTheme.value
                  ? const Icon(Icons.light_mode)
                  : const Icon(Icons.dark_mode)),
          IconButton(
              onPressed: controller.goToSearchPage,
              icon: const Icon(Icons.search)),
        ];
    }
  }

  Widget _renderTitle() {
    final tabIndex = controller.tabIndex.value;
    switch (tabIndex) {
      case 0:
        return const Text("Home");
      case 1:
        return const Text("Contacts");
      case 2:
        return const Text("User");
      default:
        return const Text("Conversations");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Obx(
            () => AppBar(
              backgroundColor: MyTheme.getAppBarColor(
                  sc.isLightTheme.value)["backgroundColor"],
              shadowColor:
                  MyTheme.getAppBarColor(sc.isLightTheme.value)["shadowColor"],
              foregroundColor: MyTheme.getAppBarColor(
                  sc.isLightTheme.value)["foregroundColor"],
              leading: const Icon(Icons.menu),
              title: _renderTitle(),
              actions: showActions(context),
            ),
          )),
      body: Obx(() => SwipeDetector(
          onSwipeLeft: controller.onSwipeLeft,
          onSwipeRight: controller.onSwipeRight,
          child: IndexedStack(
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
                        page: () => SearchView(),
                        binding: SearchBinding());
                  } else if (settings.name == Routes.CHAT) {
                    return GetPageRoute(
                        routeName: Routes.CHAT,
                        page: () => ChatView(),
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
                },
              ),
              Navigator(
                initialRoute: Routes.USER,
                onGenerateRoute: (settings) {
                  if (settings.name == Routes.USER) {
                    return GetPageRoute(
                        routeName: Routes.USER,
                        page: () => UserView(),
                        binding: UserBinding());
                  } else if (settings.name == Routes.SETTINGS) {
                    return GetPageRoute(
                        routeName: Routes.SETTINGS,
                        page: () => SettingsView(),
                        binding: SettingsBinding());
                  }
                },
              )
            ],
          ))),
      // bottomNavigationBar: Obx(() => BottomNavigationBar(
      //       currentIndex: controller.tabIndex.value,
      //       showUnselectedLabels: false,
      //       showSelectedLabels: false,
      //       unselectedItemColor: Colors.grey,
      //       selectedItemColor: Colors.red,
      //       items: const [
      //         BottomNavigationBarItem(
      //             icon: FaIcon(FontAwesomeIcons.house), label: "Home"),
      //         BottomNavigationBarItem(
      //             icon: FaIcon(FontAwesomeIcons.solidAddressBook),
      //             label: "Contact"),
      //         BottomNavigationBarItem(
      //             icon: FaIcon(FontAwesomeIcons.solidUser), label: "User"),
      //       ],
      //       onTap: controller.onTabClick,
      //     )),
    );
  }
}
