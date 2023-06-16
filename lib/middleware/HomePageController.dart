import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timetalk/middleware/BuildContextHolder.dart';
import 'package:timetalk/models/alert_model.dart';
import 'package:timetalk/screens/video_call/incoming_call_screen.dart';
import 'package:get_it/get_it.dart';

class HomePageController extends GetxController {
  RxInt isShow = 0.obs;
  RxList<AlertModel> notifications = <AlertModel>[].obs;
  RxInt notificationCount = 0.obs;

  RxList onlineUsers = [].obs;

  void setShow(int isShow) {
    print("ss");
    this.isShow.value = isShow;
  }

  // void getData() {
  //   final buildContextHolder = GetIt.instance.get<BuildContextHolder>();
  //   final context = buildContextHolder.context;
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => IncomingCallScreen(),
  //   ));
  // }

  void addNewNotficiation(AlertModel value) {
    notifications.add(value);
    notifications.refresh();
    notificationCount++;
  }

  void setNotificationCountReset() {
    notificationCount.value = 0;
  }

  void removeAllAlert() {
    notifications.clear();
    notificationCount.value = 0;
  }

  List<AlertModel> getNotification() {
    notifications.refresh();
    return notifications.value;
  }

  void addnewOnlineUser(String value) {
    onlineUsers.add(value);
    onlineUsers.refresh();
  }
}
