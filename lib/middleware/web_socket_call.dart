import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:timetalk/constants/AlertType.dart';
import 'package:timetalk/constants/ApiConstants.dart';
import 'package:timetalk/middleware/HomePageController.dart';
import 'package:timetalk/models/alert_model.dart';
import 'package:timetalk/models/call_model.dart';
import 'package:timetalk/models/notification_model.dart';
import 'package:timetalk/services/call_services.dart';
import 'package:vibration/vibration.dart';

import '../screens/video_call/incoming_call_screen.dart';
import 'notification_loop_service.dart';

WebSocket? _webSocket;
List<NotificationModel> notification = [];
CallService callService = CallService();
HomePageController controller = Get.put(HomePageController());

void connectCallWebSocket(int userId) async {
  await initializeNotification();
  bool loopExec = true;
  bool callUiopen = true;
  String nextcalldatetime = "";
  final box = GetStorage();
  try {
    var jwt = await box.read("jwt");
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer ${jwt}',
    };

    _webSocket = await WebSocket.connect(
      '${ApiConstants.cloudwsaddress}/?userId=${userId}',
      headers: headers,
    );
    _webSocket!.listen((data) {
      // Handle the data received from the server here
      List<CallModel> callModel = jsontoCallModel(data);
      for (var element in callModel) {
        if (callModel.length != 0) {
          //go();
          loopExec = true;
        }

        nextcalldatetime = callModel[0].calldate.toString();
        Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
          DateTime now = DateTime.now();
          String formattedDateTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
          print(
              "formattedDateTime next: ${nextcalldatetime} now: ${formattedDateTime}  ");

          if (nextcalldatetime == formattedDateTime && callUiopen) {
            callUiopen = false;

            print("Moved to screen ${nextcalldatetime} ${formattedDateTime}");

            Vibration.vibrate(
                pattern: [500, 1000, 500, 2000], intensities: [1, 255]);

            flutterLocalNotificationsPlugin.show(
              888,
              'Time to talk',
              'Call is Starting Now',
              NotificationDetails(
                  android: AndroidNotificationDetails(
                      'your other channel id', 'your other channel name')),
            );
            Get.to(IncomingCallScreen(
              title: callModel[0].title,
              timeduration: callModel[0].calltime,
            ));
            callModel.clear();
            timer.cancel();
          }
        });

        if (callModel!.length > 0 && (loopExec || notification.isEmpty)) {
          controller.addNewNotficiation(AlertModel(
              id: callModel[0].id,
              alertType: AlertType.call,
              title: element.title,
              message: "${element.title} at ${element.calldate}",
              datetime: DateTime.now().toIso8601String()));

          nextcalldatetime = callModel[0].calldate.toString();
          Vibration.vibrate(
              pattern: [500, 1000, 500, 2000], intensities: [1, 255]);

          loopExec = false;
          callUiopen = true;

          updateCallId(callModel[0].id);

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
    }, onError: (error) {
      print('Error: $error');
    }, onDone: () {
      print('WebSocket closed');
    });
  } catch (e) {
    print('Error connecting to WebSocket: $e');
  }
}

Future<void> updateCallId(int id) async {
  await callService.updateAvaialbleCalls(id);
}

void sendWebSocketMessage(Map<String, dynamic> data) {
  if (_webSocket != null && _webSocket!.readyState == WebSocket.open) {
    _webSocket!.add(jsonEncode(data));
  }
}

void closeWebSocket() {
  if (_webSocket != null && _webSocket!.readyState == WebSocket.open) {
    _webSocket!.close();
  }
}

Future<void> initializeNotification() async {
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
}
