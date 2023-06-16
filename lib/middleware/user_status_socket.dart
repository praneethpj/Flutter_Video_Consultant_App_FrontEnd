import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:timetalk/constants/AlertType.dart';
import 'package:timetalk/constants/ApiConstants.dart';
import 'package:timetalk/middleware/HomePageController.dart';
import 'package:timetalk/models/alert_model.dart';
import 'package:timetalk/models/call_model.dart';
import 'package:timetalk/models/notification_model.dart';
import 'package:timetalk/services/call_services.dart';
import 'package:vibration/vibration.dart';

import '../screens/common_widget/pulse_animation.dart';
import '../screens/video_call/incoming_call_screen.dart';
import 'notification_loop_service.dart';

Socket? socketIO;
final _onlineStatusCache = <String, Completer<bool>>{};
void connectUserStatusWebSocket(String userId) async {
  print("Online che3ck " + userId);
  //${ApiConstants.cloudmsgaddress}/?userId=${userId}
  socketIO =
      io('${ApiConstants.cloudmsgaddress}/?userId=${userId}', <String, dynamic>{
    'transports': ['websocket'],
  });
  print("Online che3ck " + userId);
  socketIO!.on('connect', (_) {
    String clientId = userId;
    socketIO!.emit('register', clientId);
  });
  print("Online che3ck " + userId);
}

Future<bool> checkUserOnline(String userId) {
  if (_onlineStatusCache.containsKey(userId)) {
    return _onlineStatusCache[userId]!.future;
  }

  final completer = Completer<bool>();
  socketIO!.emit('checkOnline', userId);
  socketIO!.once('onlineStatus', (data) {
    if (data['userId'] == userId) {
      final isOnline = data['isOnline'] as bool;
      completer.complete(isOnline);

      if (_onlineStatusCache.containsKey(userId)) {
        _onlineStatusCache[userId]!.complete(isOnline);
      } else {
        _onlineStatusCache[userId] = Completer<bool>()..complete(isOnline);
      }
    }
  });

  _onlineStatusCache[userId] = completer;
  return completer.future;
}

Future<Widget> onlineOfflineWidget(String userid) async {
  print("userid ${userid}");
  var isOnline = await checkUserOnline(userid);
  return Expanded(child: PulseAnimation(isOnline: isOnline));
}
