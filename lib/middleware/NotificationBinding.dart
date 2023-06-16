import 'package:get/get.dart';
import 'package:timetalk/middleware/HomePageController.dart';

class NotificationBinding implements Bindings {
// default dependency
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageController());
  }
}
