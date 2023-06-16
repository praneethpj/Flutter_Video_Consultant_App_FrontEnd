import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timetalk/models/alert_model.dart';
import 'package:timetalk/services/feature_service.dart';
import '../../constants/AlertType.dart';
import '../../middleware/HomePageController.dart';
import '../user_profile_dashboard/listofbook_screen/list_of_book_screen.dart';

class NotificationMessageScreen extends StatefulWidget {
  const NotificationMessageScreen({super.key});

  @override
  State<NotificationMessageScreen> createState() =>
      _NotificationMessageScreenState();
}

class _NotificationMessageScreenState extends State<NotificationMessageScreen> {
  HomePageController controller = Get.find<HomePageController>();
  List<AlertModel>? alerts;
  var featureService = FeaturelService();

  @override
  void initState() {
    super.initState();
    loadValues();
    updateNotifications();
  }

  updateNotifications() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    featureService.updateAllNotifications();
  }

  loadValues() {
    Future.delayed(
      Duration(seconds: 1),
      () {
        _fetchNotificationData();
        _onRefresh();
        setState(() {});
      },
    );

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _fetchNotificationData());
  }

  Future<void> _fetchNotificationData() async {
    alerts = await controller.getNotification();
    setState(() {});
  }

  Future<void> _onRefresh() async {
    await _fetchNotificationData();
  }

  @override
  Widget build(BuildContext context) {
    controller.notificationCount.value = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        leading: IconButton(
            onPressed: () {
              // controller.removeAllAlert();
              // _fetchNotificationData();
              // _onRefresh();
              Get.back();
            },
            icon: Icon(CupertinoIcons.back)),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Visibility(
          visible: alerts != null,
          child: ListView.builder(
            itemCount: alerts?.length ?? 0,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return alerts![index].alertType == AlertType.newappoinment
                  ? GestureDetector(
                      onTap: () => Get.to(ListOfBookScreen()),
                      child: ListTile(
                        leading: Icon(CupertinoIcons.app_badge_fill),
                        title: Text(alerts![index].message),
                        subtitle: Text(
                            "${alerts![index].title} @ ${alerts![index].datetime}"),
                      ),
                    )
                  : ListTile(
                      title: Text(alerts![index].message),
                      subtitle: Text(
                          "${alerts![index].title} @ ${alerts![index].datetime}"),
                    );
            },
          ),
          replacement: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
