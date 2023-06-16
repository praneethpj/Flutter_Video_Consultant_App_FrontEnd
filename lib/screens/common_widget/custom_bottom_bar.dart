import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:get_storage/get_storage.dart';
import '../../middleware/HomePageController.dart';

class PersistentBottomBarScaffold extends StatefulWidget {
  /// pass the required items for the tabs and BottomNavigationBar
  final List<PersistentTabItem> items;

  const PersistentBottomBarScaffold({Key? key, required this.items})
      : super(key: key);

  @override
  _PersistentBottomBarScaffoldState createState() =>
      _PersistentBottomBarScaffoldState();
}

class _PersistentBottomBarScaffoldState
    extends State<PersistentBottomBarScaffold> {
  HomePageController controller = Get.find<HomePageController>();
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// Check if curent tab can be popped
        if (widget.items[_selectedTab].navigatorkey?.currentState?.canPop() ??
            false) {
          widget.items[_selectedTab].navigatorkey?.currentState?.pop();
          return false;
        } else {
          // if current tab can't be popped then use the root navigator
          return true;
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedTab,
          children: widget.items
              .map((page) => Navigator(
                    key: page.navigatorkey,
                    onGenerateInitialRoutes: (navigator, initialRoute) {
                      return [
                        MaterialPageRoute(builder: (context) => page.tab)
                      ];
                    },
                  ))
              .toList(),
        ),

        /// Define the persistent bottom bar
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Fixed
          backgroundColor:
              Color.fromARGB(255, 255, 255, 255), // <-- This works for fixed
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedTab,
          onTap: (index) {
            /// Check if the tab that the user is pressing is currently selected
            if (index == _selectedTab) {
              /// if you want to pop the current tab to its root then use
              widget.items[index].navigatorkey?.currentState
                  ?.popUntil((route) => route.isFirst);

              /// if you want to pop the current tab to its last page
              /// then use
              // widget.items[index].navigatorkey?.currentState?.pop();
            } else {
              setState(() {
                _selectedTab = index;
              });
            }
          },
          items: widget.items
              .map((item) => BottomNavigationBarItem(
                  icon: item.isCountbadge
                      ? Badge(
                          label: Expanded(
                              child: Obx(() =>
                                  Text("${controller.notificationCount}"))),
                          child: Icon(item.icon),
                        )
                      : Icon(item.icon),
                  label: item.title))
              .toList(),
        ),
      ),
    );
  }
}

/// Model class that holds the tab info for the [PersistentBottomBarScaffold]
class PersistentTabItem {
  final Widget tab;
  final GlobalKey<NavigatorState>? navigatorkey;
  final String title;
  final IconData icon;
  final bool isCountbadge;

  PersistentTabItem(
      {required this.tab,
      this.navigatorkey,
      required this.title,
      required this.icon,
      required this.isCountbadge});
}
