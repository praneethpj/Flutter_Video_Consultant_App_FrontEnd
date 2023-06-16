import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class DataHelper {
  static DateTime? date;
  static DateTime datenow = DateTime.now();

  static var currentDate;
  static var currentMonth;
  static var currentMonthNum;
  static var currentYear;

  static void init() {
    date = Jiffy().dateTime;
    var a = getJeffy(DateTime.now(), 1, "1");
    var b = addDay(DateTime.now(), 1, "1");
    var c = subtractDay(DateTime.now(), 1, "1");
    currentDate = DateFormat('d').format(DataHelper.date!);
    currentMonth = DateFormat('MMM').format(DataHelper.date!);
    currentMonthNum = int.parse(DateFormat('M').format(DataHelper.date!));
    currentYear = DateFormat('yyyy').format(DataHelper.date!);
    ;
  }

  static Jiffy getJeffy(DateTime d, int currentMonthNum, String currentDay) {
    return Jiffy(DateTime(d.year, currentMonthNum, int.parse(currentDay)));
  }

  static Jiffy addDay(DateTime d, int currentMonthNum, String currentDay) {
    return Jiffy(DateTime(d.year, currentMonthNum, int.parse(currentDay)))
        .add(days: 1);
  }

  static Jiffy subtractDay(DateTime d, int currentMonthNum, String currentDay) {
    return Jiffy(DateTime(d.year, currentMonthNum, int.parse(currentDay)))
        .subtract(days: 1);
  }

  static int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  static showInformationMessage(String title, String messages) {
    Get.snackbar('Updated', 'You have been Successfully book a appoinment',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.black38,
        colorText: Colors.white);
  }
}
