import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:timetalk/middleware/BuildContextHolder.dart';
import 'package:timetalk/middleware/HomePageController.dart';
import 'package:timetalk/middleware/navigation_service.dart';
import 'package:timetalk/models/call_model.dart';
import 'package:timetalk/models/notification_model.dart';
import 'package:timetalk/screens/authentication_screen.dart';
import 'package:timetalk/screens/video_call/incoming_call_screen.dart';
import 'package:timetalk/screens/common_widget/custom_bottom_bar.dart';
import 'package:timetalk/screens/home_screen.dart';
import 'package:timetalk/screens/profile_screen.dart';
import 'package:timetalk/screens/user_profile_dashboard.dart';
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
import '../main.dart';
import '../middleware/locator.dart';
import 'package:vibration/vibration.dart';

import '../models/alert_model.dart';

class NotificationLoopService {}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
BuildContext? _buildContext;
Future<void> initializeService(BuildContext buildContext) async {
  final service = FlutterBackgroundService();
  _buildContext = buildContext;
  // _customBuildContext = buildContext;
  //go();

  /// OPTIONAL, using custom notification channel id
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title

    // description
    importance: Importance.low, // importance must be at low or higher level
  );

  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: IOSInitializationSettings(),
      ),
    );
  } else {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const IconData ac_unit_outlined =
        IconData(0xe005, fontFamily: 'MaterialIcons');
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_flutternotification');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

List<NotificationModel> notification = [];

Future<void> showNotification1(
    int id, String title, String body, int seconds) async {
  // await initializeService();

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'big text channel id',
    'big text channel name',
  );
  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'big text title', 'silent body', platformChannelSpecifics);
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  CallService callService = CallService();

  final box = GetStorage();
  bool loopExec = true;
  bool callUiopen = true;
  String nextcalldatetime = "";
  // bring to foreground
  //Add a function to insert notification data and remove
  SharedPreferences preferences1 = await SharedPreferences.getInstance();
  //await preferences.clear();
  final log = preferences1.getStringList('call') ?? <String>[];

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    bool IsjwtValid =
        (["", null, false, 0, "null", 'null', Null].contains(box.read("jwt")));

    // await showNotification();
    if (service is AndroidServiceInstance) {
      print("box.read(jwt) ${IsjwtValid != true}  ${box.read("jwt")} ");
      if (await service.isForegroundService()) {
        if (IsjwtValid != true) {
          print("Running ");

          List<CallModel> callModel = await callService.checkAvaialbleCalls();
          print("callModel ${callModel.length}");
          //callModel.forEach((element1) {
          //  notification.forEach((element) {
          // print("element ${element.date}");
          // print("element1 ${callModel[0].calldate} ${callModel[0].userId}");
          if (callModel.length != 0) {
            //go();
            loopExec = true;
          }
          // });
          //});

          DateTime now = DateTime.now();
          String formattedDateTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

          // notification.forEach((element) {
          print(
              "formattedDateTime next: ${nextcalldatetime} now: ${formattedDateTime} ${callUiopen}");

          if (nextcalldatetime == formattedDateTime && callUiopen) {
            callUiopen = false;

            // Get.to(CallScreen());
            print("Moved to screen ${nextcalldatetime} ${formattedDateTime}");

            log.add("PPPP");
            // await preferences1.setStringList('call', log);

            Vibration.vibrate(
                pattern: [500, 1000, 500, 2000], intensities: [1, 255]);

            flutterLocalNotificationsPlugin.show(
              888,
              'Time to talk',
              'Call Should be Started NOW',
              NotificationDetails(
                  android: AndroidNotificationDetails(
                      'your other channel id', 'your other channel name')),
            );

            // Navigator.push(_buildContext!,
            //     MaterialPageRoute(builder: (context) => CallScreen()));
          }
          //});

          print(" notification.isEmpty ${notification.isEmpty}");
          if (callModel!.length > 0 && (loopExec || notification.isEmpty)) {
            // notification.add(NotificationModel(
            //     date: callModel[0].calldate.toString(),
            //     time: callModel[0].calltime));
            nextcalldatetime = callModel[0].calldate.toString();
            Vibration.vibrate(
                pattern: [500, 1000, 500, 2000], intensities: [1, 255]);
            print("Running notifiaction nextcalldatetime: ${nextcalldatetime}");
            loopExec = false;
            callUiopen = true;
            await callService.updateAvaialbleCalls(callModel[0].id);

            // showNotification1(1, "test", "bb", 1);

            /// OPTIONAL for use custom notification
            /// the notification id must be equals with AndroidConfiguration when you call configure() method.
            //   print("You have a Call at ${callModel[0].starttime}");
            //  int id = Random().nextInt(1000);

            flutterLocalNotificationsPlugin.show(
              888,
              'Time to talk',
              ' ${callModel[0].title} AT ${callModel[0].calltime}',
              NotificationDetails(
                  android: AndroidNotificationDetails(
                      'your other channel id', 'your other channel name')),
            );
            // await flutterLocalNotificationsPlugin.cancel(888);
          }
        }
      }
    }

    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}
