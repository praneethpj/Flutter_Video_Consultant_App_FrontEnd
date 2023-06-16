import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:timetalk/helpers/ConvertHelper.dart';

import 'call_feedback_screen.dart';

const appId = "cb7cdcba24424d9e8a1fefb3668714a5";
const token = "cb7cdcba24424d9e8a1fefb3668714a5";
const channel = "talktimef";

class VideoCallScreen extends StatefulWidget {
  String professionalId;
  String userid;
  String timeduration;
  VideoCallScreen(
      {Key? key,
      required this.professionalId,
      required this.userid,
      required this.timeduration})
      : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreen();
}

class _VideoCallScreen extends State<VideoCallScreen> {
  CountdownTimerController? controller;
  int? endTime;

  String? professionalId;
  String? userId;
  late AgoraClient client;

  var storage = GetStorage();

  void initializeAgoraClient() {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "cb7cdcba24424d9e8a1fefb3668714a5",
        channelName: "${professionalId},${userId}",
        username: userId ?? "user",
      ),
    );
  }

  int timeinmiutes = 0;
  @override
  void initState() {
    super.initState();
    professionalId = widget.professionalId;
    userId = widget.userid;

    List<String> startParts = widget.timeduration.split('-');
    timeinmiutes =
        ConvertHelper.calculateTotalMinutes(startParts[0], startParts[1]);
    endTime = ConvertHelper.convertMinutesToEndTime(timeinmiutes);
    print("endtime ${endTime}");
    initializeAgoraClient();
    initAgora();
    controller = CountdownTimerController(endTime: endTime!, onEnd: onEnd);
  }

  void initAgora() async {
    await client.initialize();
  }

  Future<void> endCall() async {
    client.release();
    List<String> startParts = widget.timeduration.split('-');
    if (professionalId != await storage.read("username")) {
      Get.to(CallFeedBackScreen(
        callUserId: userId!,
        endtime: startParts[0],
        starttime: startParts[1],
        professionalId: professionalId!,
        talkcount: 1,
        talkhours: timeinmiutes,
      ));
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Get.offNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.oneToOne,
              enableHostControls: false,
            ),
            AgoraVideoButtons(
              client: client,
              addScreenSharing: false,
              onDisconnect:
                  endCall, // Call endCall function when end call button is pressed
            ),
            CountdownTimer(
              controller: controller,
              onEnd: onEnd,
              endTime: endTime,
              textStyle: TextStyle(
                color: Colors.white,
                backgroundColor: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onEnd() {
    endCall();
  }
}
