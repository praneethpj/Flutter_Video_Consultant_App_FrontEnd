import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:timetalk/helpers/DataHelper.dart';
import 'package:timetalk/middleware/BuildContextHolder.dart';
import 'package:timetalk/screens/authentication/phone_authentication.dart';
import 'package:timetalk/screens/authentication_screen.dart';
import 'package:timetalk/screens/booking_screen.dart';
import 'package:timetalk/screens/signup_screen.dart';
import 'package:timetalk/screens/video_call/incoming_call_screen.dart';
import 'package:timetalk/screens/home_screen.dart';
import 'package:timetalk/screens/parent_home_screen.dart';
import 'package:timetalk/screens/profile_screen.dart';
import 'package:get_storage/get_storage.dart';

import 'middleware/HomePageController.dart';
import 'middleware/NotificationBinding.dart';
import 'middleware/locator.dart';
import 'middleware/navigation_service.dart';
import 'middleware/web_socket_call.dart';

final navigatorKey = GlobalKey<NavigatorState>();
load() async {
  Get.lazyPut(() => HomePageController());

  await GetStorage.init();
  locator.registerLazySingleton(() => NavigationService());
  DataHelper.init();

  // await GetStorage.init("container");
}

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: NotificationBinding(),
      navigatorKey: navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => HomeScreen());
          case '/callScreen':
            return MaterialPageRoute(
                builder: (_) => IncomingCallScreen(
                      title: "",
                      timeduration: "",
                    ));
          case '/videocallscreen':
            return MaterialPageRoute(
                builder: (_) => IncomingCallScreen(
                      title: "Asha, You have a call with Mr.Praneeth",
                      timeduration: "",
                    ));
          case '/authentication':
            return MaterialPageRoute(
                builder: (_) => AuthenticationScreen(
                      isPaymentProcess: false,
                    ));
          default:
            return null;
        }
      },
      debugShowCheckedModeBanner: false,
      title: 'Minit With',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: HomePage(),
        // floatingActionButton: FloatingActionButton.extended(
        //   heroTag: 'uniqueTag',
        //   label: Row(
        //     children: [Icon(Icons.phone), Text('Call')],
        //   ),
        //   onPressed: () {},
        // ),
      ),
    );
  }
}

class NoScalingAnimation extends FloatingActionButtonAnimator {
  double? _x;
  double? _y;
  @override
  Offset getOffset({Offset? begin, Offset? end, double? progress}) {
    _x = begin!.dx + (end!.dx - begin.dx) * progress!;
    _y = begin.dy + (end.dy - begin.dy) * progress;
    return Offset(_x!, _y!);
  }

  @override
  Animation<double> getRotationAnimation({Animation<double>? parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent!);
  }

  @override
  Animation<double> getScaleAnimation({Animation<double>? parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent!);
  }
}
