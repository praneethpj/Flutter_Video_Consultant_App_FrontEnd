import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetalk/constants/AlertType.dart';
import 'package:timetalk/middleware/HomePageController.dart';
import 'package:timetalk/middleware/notification_loop_service.dart';
import 'package:timetalk/models/call_model.dart';
import 'package:timetalk/screens/booking_screen.dart';
import 'package:timetalk/screens/consultants_list_screen.dart';
import 'package:timetalk/screens/notification_message/NotificationMessageScreen.dart';
import 'package:timetalk/screens/personal_message/personal_message_screen.dart';
import 'package:timetalk/screens/video_call/call_feedback_screen.dart';
import 'package:timetalk/screens/video_call/incoming_call_screen.dart';
import 'package:timetalk/screens/common_widget/custom_wtext.dart';
import 'package:timetalk/screens/home_widget/category_type.dart';
import 'package:timetalk/screens/home_widget/side_list_type.dart';
import 'dart:math' as math;

import 'package:timetalk/services/call_services.dart';

import '../models/alert_model.dart';
import 'consultants_list_screen_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomePageController controller = Get.put(HomePageController());
  CallService callService = CallService();
  final box = GetStorage();
  bool loopExec = true;
  bool callUiopen = true;
  String nextcalldatetime = "";

  bool getTimeStatus(DateTime targetTime, int minute) {
    DateTime now = DateTime.now();
    targetTime = targetTime.subtract(Duration(minutes: minute));

    print("getTimeStatus now ${now} target ${targetTime}");

    if (targetTime.isBefore(now)) {
      return false;
    } else if (targetTime.isAfter(now)) {
      return false;
    } else {
      return true;
    }
  }

  load() async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      bool IsjwtValid = (["", null, false, 0, "null", 'null', Null]
          .contains(box.read("jwt")));

      print("box.read(jwt) ${IsjwtValid != true}  ${box.read("jwt")} ");

      if (IsjwtValid != true) {
        print("Running ");

        List<CallModel> callModel = await callService.checkAvaialbleCalls();
        print("callModel ${callModel.length}");

        if (callModel.length != 0) {
          loopExec = true;
        }

        DateTime now = DateTime.now();
        String formattedDateTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

        print(
            "homeformattedDateTimess next ${nextcalldatetime} now ${formattedDateTime} ${callUiopen}");

        if (nextcalldatetime != "") {
          if (getTimeStatus(DateTime.parse(nextcalldatetime), 1)) {
            controller.addNewNotficiation(AlertModel(
                id: callModel[0].id,
                alertType: AlertType.call,
                title: "Reminder",
                message: 'New Call ',
                datetime: DateTime.now().toIso8601String()));
          }
        }

        if (nextcalldatetime == formattedDateTime && callUiopen) {
          callUiopen = false;

          // Get.to(CallScreen());
          print("Moved to screen ${nextcalldatetime} ${formattedDateTime}");

          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => IncomingCallScreen()));

          Get.to(IncomingCallScreen(
            title: callModel[0].title,
            timeduration: callModel[0].calltime,
          ));
        }
//NEW code impl
        // print(" notification.isEmpty ${notification.isEmpty}");
        // if (callModel!.length > 0 && (loopExec || notification.isEmpty)) {
        //   nextcalldatetime = callModel[0].calldate.toString();

        //   print("Running notifiaction nextcalldatetime: ${nextcalldatetime}");
        //   loopExec = false;
        //   callUiopen = true;
        //   await callService.updateAvaialbleCalls(callModel[0].id);
        // }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // load();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    var _textcontroller = TextEditingController();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          return;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Expanded(
                      //     child: Obx(() =>
                      //         Text("is showing ${controller.isShow.value}"))),
                      SizedBox(
                        width: _width * 0.8,
                        height: 60,
                        child: TextField(
                            controller: _textcontroller,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 244, 240, 240),
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText: "Search Consultant",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                suffixIcon: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(2, 2, 3, 2),
                                    child: Container(
                                      color: Colors.white,
                                      height: 15,
                                      width: 15,
                                      child: IconButton(
                                        onPressed: (() {
                                          // Get.to(IncomingCallScreen(
                                          //     title:
                                          //         "Jayagosa, you have call, with Ma",
                                          //     timeduration: "10:00-10:30"));

                                          Get.to(ConsultantsListSearch(
                                            searchtext: _textcontroller.text,
                                          ));
                                        }),
                                        icon: Icon(Icons.horizontal_distribute),
                                        color: Colors.grey,
                                        highlightColor: Colors.white,
                                        enableFeedback: true,
                                      ),
                                    ),
                                  ),
                                ),
                                border: InputBorder.none)),
                      ),
                      IconButton(
                          color: Colors.grey,
                          highlightColor: Colors.white,
                          onPressed: () {
                            Get.to(NotificationMessageScreen());
                          },
                          icon: Badge(
                            label: Expanded(
                                child: Obx(() =>
                                    Text("${controller.notificationCount}"))),
                            child: Icon(CupertinoIcons.bell_solid),
                          )),
                    ],
                  ),
                ),
                CategoryType(),
                SizedBox(
                  height: _height / 30,
                  width: 100,
                ),
                Container(
                  child: const CustomTextWidget(
                    text: "Top Popular Consultant",
                    size: 20,
                  ),
                ),
                Container(child: SideScrollProfessionals()),
                SizedBox(
                  height: _height / 30,
                  width: 100,
                ),
                Container(
                  child: const CustomTextWidget(
                    text: "Most recently Consultant",
                    size: 20,
                  ),
                ),
                SideScrollProfessionals(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
