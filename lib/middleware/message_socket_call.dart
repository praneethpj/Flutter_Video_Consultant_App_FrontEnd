import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

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

void connectMessageWebSocket(int userId) async {
  await initializeNotification();
  bool loopExec = true;
  bool callUiopen = true;
  String nextcalldatetime = "";
  final box = GetStorage();
  try {
    print("Message Web init");
    var jwt = await box.read("jwt");
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer ${jwt}',
    };

    _webSocket = await WebSocket.connect(
      '${ApiConstants.cloudmsgaddress}/?userId=${userId}',
      headers: headers,
    );
    _webSocket!.listen((data) {
      // Handle the data received from the server here
      print("Message Web socket Message ${data}");
    }, onError: (error) {
      print('Message Web socket Error: $error');
    }, onDone: () {
      print('Message Web socket WebSocket closed');
    });
  } catch (e) {
    print('Message Web socket Error connecting to WebSocket: $e');
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
