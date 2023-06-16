import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:timetalk/middleware/BuildContextHolder.dart';
import 'package:timetalk/middleware/HomePageController.dart';
import 'package:timetalk/middleware/navigation_service.dart';
import 'package:timetalk/middleware/notification_loop_service.dart';
import 'package:timetalk/models/call_model.dart';
import 'package:timetalk/models/notification_model.dart';
import 'package:timetalk/screens/authentication/utils/authentication.dart';
import 'package:timetalk/screens/authentication_screen.dart';
import 'package:timetalk/screens/booking_screen.dart';
import 'package:timetalk/screens/common_widget/custom_bottom_bar.dart';
import 'package:timetalk/screens/home_screen.dart';
import 'package:timetalk/screens/personal_message/list_of_chat_item_screen.dart';
import 'package:timetalk/screens/personal_message/personal_message_screen.dart';
import 'package:timetalk/screens/profile_screen.dart';
import 'package:timetalk/screens/user_profile_dashboard.dart';
import 'package:timetalk/screens/video_call/video_call_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetalk/services/call_services.dart';
import 'package:get_it/get_it.dart';
import '../middleware/locator.dart';
import '../middleware/message_socket_call.dart';
import '../middleware/user_status_socket.dart';
import '../middleware/web_socket_call.dart';
import 'notification_message/NotificationMessageScreen.dart';
import 'video_call/incoming_call_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//BuildContext? buildContext;

class _HomePageState extends State<HomePage> {
  final _tab1navigatorKey = GlobalKey<NavigatorState>();

  final _tab2navigatorKey = GlobalKey<NavigatorState>();

  final _tab3navigatorKey = GlobalKey<NavigatorState>();

  final _tab4navigatorKey = GlobalKey<NavigatorState>();

  final _tab5navigatorKey = GlobalKey<NavigatorState>();
  CallService callService = CallService();

  static late BuildContext _buildContext;
  final box = GetStorage();

  startService(BuildContext buildContext) async {
    //New code imp
    await initializeService(
        buildContext); // This background service is not need if backend support push notifcations.
    var userid = await box.read("id") ?? 0;
    connectCallWebSocket(userid);
    connectUserStatusWebSocket(userid.toString());
    //connectMessageWebSocket(userid);
  }

  Future load() async {
    //var id = box.read("id");
    var jwt = await box.read("jwt");
    bool IsjwtValid =
        (["", null, false, 0, "null", 'null', Null].contains(jwt));

    if (IsjwtValid == true) {
      //Navigator.pushNamed(context, "/authentication");
      //Get.to(Authentication());
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.pushNamed(context, "/authentication"));
    }
    return IsjwtValid;
  }

  // move() {
  //   //navService.pushNamed("/callScreen");
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => IncomingCallScreen(),
  //   ));
  // }

  void _initiate(BuildContext context) {
    load();
  }

  @override
  void initState() {
    super.initState();
    //navService.pushNamed("/callScreen");
    Get.lazyPut<HomePageController>(() => HomePageController());
    WidgetsBinding.instance!.addPostFrameCallback((_) => _initiate(context));
  }

  @override
  Widget build(BuildContext context) {
    //   Get.put(HomePageController(context: context));
    // GetIt.instance.registerSingleton<BuildContextHolder>(BuildContextHolder(context));

    startService(context);
    return FutureBuilder(
      future: load(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PersistentBottomBarScaffold(
            items: [
              PersistentTabItem(
                  tab: HomeScreen(),
                  icon: Icons.home,
                  title: 'Home',
                  navigatorkey: _tab1navigatorKey,
                  isCountbadge: false),
              PersistentTabItem(
                  tab: ListOfChatItemScreen(),
                  icon: CupertinoIcons.chat_bubble,
                  title: 'Messages',
                  navigatorkey: _tab2navigatorKey,
                  isCountbadge: false),
              PersistentTabItem(
                  tab: UserProfileDashboard(),
                  icon: Icons.person,
                  title: 'My Profile',
                  navigatorkey: _tab3navigatorKey,
                  isCountbadge: false),
              // PersistentTabItem(
              //     tab: NotificationMessageScreen(),
              //     icon: CupertinoIcons.bell_solid,
              //     title: 'Alerts',
              //     navigatorkey: _tab4navigatorKey,
              //     isCountbadge: true),
              // PersistentTabItem(
              //     tab: IncomingCallScreen(),
              //     icon: CupertinoIcons.bell_solid,
              //     title: 'Call',
              //     navigatorkey: _tab5navigatorKey,
              //     isCountbadge: true),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

go() {
  final NavigationService _navigationService = locator<NavigationService>();

  //Navigator.pushNamed(buildContext!, "/callScreen");
  //_HomePageState().move();
  _navigationService.pushNamed("/callScreen");
  //_HomePageState.navigateCall();
  print("Call screen");
  // Navigator.of(_HomePageState._buildContext)
  //     .push(MaterialPageRoute(builder: (context) => CallScreen()));
}
