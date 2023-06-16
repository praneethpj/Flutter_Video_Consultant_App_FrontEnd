import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:timetalk/constants/CustomColors.dart';
import 'package:timetalk/helpers/DataHelper.dart';
import 'package:timetalk/middleware/user_payment_object.dart';
import 'package:timetalk/models/schedule_model.dart';
import 'package:timetalk/screens/common_widget/gradient_button.dart';
import 'package:timetalk/screens/make_payment_screen.dart';

import '../services/api_service.dart';

class BookingScreen extends StatefulWidget {
  final int profileId;
  final double costperhour;
  final String profileName;
  final String profileType;
  final String title;
  const BookingScreen(
      {super.key,
      required this.profileId,
      required this.costperhour,
      required this.profileName,
      required this.profileType,
      required this.title});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  UserPaymentObject userPaymentObject = UserPaymentObject();
  ApiService apiService = ApiService();
  String currentDay = "";
  String currentMonth = "";
  String currentYear = "";
  int currentMonthNum = 0;
  bool isToday = true;
  int dayId = 0;

  String profilename = "";
  String bookeddate = "";
  int selectedDayId = 0;
  int selectedIdx = -1;

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  getDayId(String abr) {
    switch (abr) {
      case "Sun":
        dayId = 0;
        break;
      case "Mon":
        dayId = 1;
        break;
      case "Tue":
        dayId = 2;
        break;
      case "Wed":
        dayId = 3;
        break;
      case "Thu":
        dayId = 4;
        break;
      case "Fri":
        dayId = 5;
        break;
      case "Sat":
        dayId = 6;
        break;
    }
  }

  DateTime date = Jiffy().dateTime;

  Future<List<ScheduleModel>> getSchedule(
      int id, int dayId, String year, String month, String date) async {
    // WidgetsBinding.instance.addPostFrameCallback((_) => setToday());
    print("apiService getSchedule");

    List<ScheduleModel> pp = await apiService.getScheduleByProfileIdAndDayId(
        id, dayId, year, month, date);
    // pp.forEach((element) {
    //   print("apiService ${element.time}");
    // });

    return pp;
  }

  makeSelect(String selectedTime, int selectedDayId) {
    setState(() {
      bookeddate = "$currentYear/$currentMonth/$currentDay@$selectedTime";
      selectedDayId = selectedDayId;
      print("selectedDayId ${selectedDayId}");
    });

    userPaymentObject.dateval =
        "$currentYear/$currentMonth/$currentDay@$selectedTime";
    userPaymentObject.time = selectedTime;
    userPaymentObject.scheduleId = selectedDayId;
    userPaymentObject.realdate = "$currentYear-$currentMonth-$currentDay";
  }

  checkToday() {
    DateTime d = Jiffy().dateTime;
    DateTime date2 =
        Jiffy(DateTime(d.year, currentMonthNum, int.parse(currentDay)))
            .dateTime;
    if (calculateDifference(date2) <= 0) {
      setState(() {
        isToday = true;
      });
    } else {
      setState(() {
        isToday = false;
      });
    }

    getDayId(DateFormat("E").format(date2));
    // print(dayId);
  }

  Future<void> addDate() async {
    DateTime d = Jiffy().dateTime;
    DateTime date =
        Jiffy(DateTime(d.year, currentMonthNum, int.parse(currentDay)))
            .add(days: 1)
            .dateTime;

    currentDay = DateFormat('d').format(date);
    currentMonth = DateFormat('MMM').format(date);
    currentMonthNum = int.parse(DateFormat('M').format(date));
    currentYear = DateFormat('yyy').format(date);
    //setState(() {});
    checkToday();
  }

  void addDateAsync() {
    Future<void> future = addDate();
    // You can add a loading indicator here while the function is executing
    future.then((_) {
      // The function has completed successfully
      // Update the UI with the new date here
    }).catchError((error) {
      // An error occurred while executing the function
      // Handle the error here
    });
  }

  Future<void> substractDate() async {
    DateTime d = Jiffy().dateTime;
    DateTime date =
        Jiffy(DateTime(d.year, currentMonthNum, int.parse(currentDay)))
            .subtract(days: 1)
            .dateTime;
    setState(() {
      currentDay = DateFormat('d').format(date);
      currentMonth = DateFormat('MMM').format(date);
      currentMonthNum = int.parse(DateFormat('M').format(date));
    });
    checkToday();
  }

  Future<void> loadData() async {
    currentDay = DataHelper.currentDate;
    currentMonth = DataHelper.currentMonth;
    currentMonthNum = DataHelper.currentMonthNum;
    currentYear = DataHelper.currentYear;
    isToday = true;

    userPaymentObject.profileId = widget.profileId;
    userPaymentObject.profileType = widget.profileType;

    userPaymentObject.userfee = widget.costperhour;
    userPaymentObject.profilename = widget.profileName;
    userPaymentObject.title = widget.title;

    setState(() {});
    setToday();
    setState(() {});
  }

  setToday() {
    DateTime d = Jiffy().dateTime;
    DateTime date2 =
        Jiffy(DateTime(d.year, currentMonthNum, int.parse(currentDay)))
            .dateTime;

    getDayId(DateFormat("E").format(date2));
  }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) => substractDate());
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _size.height * 0.030,
            ),
            Container(
              color: CustomColors.googleBackground,
              height: _size.height * 0.08,
              child: Row(
                children: [
                  SizedBox(
                    width: _size.width / 6,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: isToday
                          ? IconButton(
                              onPressed: null,
                              icon: Icon(FontAwesomeIcons.arrowLeft))
                          : Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 183, 200, 255)
                                        .withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                    // changes position of shadow
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () => substractDate(),
                                icon: Icon(FontAwesomeIcons.arrowLeft),
                              ),
                            )),
                  SizedBox(
                    width: _size.width / 6,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text("${currentMonth}",
                          style: GoogleFonts.lato(
                              fontSize: 12, color: Colors.white)),
                      Text("${currentDay}",
                          style: GoogleFonts.lato(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                  SizedBox(
                    width: _size.width / 6,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 183, 200, 255)
                                .withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                            // changes position of shadow
                          ),
                        ],
                      ),
                      child: IconButton(
                          onPressed: () => {addDateAsync()},
                          icon: Icon(FontAwesomeIcons.arrowRight)),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 20,
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            SizedBox(
              height: _size.height,
              width: _size.width,
              child: FutureBuilder(
                future: getSchedule(widget.profileId, dayId, currentYear,
                    currentMonthNum.toString(), currentDay),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                        itemCount: snapshot.data!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (snapshot.data![index].available == 1) {
                                    makeSelect(snapshot.data![index].time,
                                        snapshot.data![index].id);
                                    setState(() {
                                      selectedIdx = index;
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color.fromARGB(
                                                255, 199, 199, 199)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color:
                                            snapshot.data![index].available == 1
                                                ? selectedIdx == index
                                                    ? Color.fromARGB(
                                                        255, 179, 112, 189)
                                                    : Color.fromARGB(
                                                        255, 242, 229, 245)
                                                : Color.fromARGB(
                                                    255, 236, 235, 235)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: selectedIdx == index &&
                                                  snapshot.data![index]
                                                          .available ==
                                                      1
                                              ? Text(
                                                  "${snapshot.data![index].time}",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              : Text(
                                                  "${snapshot.data![index].time}")),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        children: [
          Container(
            height: 50,
            margin: const EdgeInsets.all(10),
            child: GradientButton(
                title: "Back",
                type: GradientButtonType.PAYMENTBUTTON,
                function: () => {Navigator.of(context).pop()}),
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.all(10),
            child: bookeddate.isEmpty
                ? GradientButton(
                    title: "Next",
                    type: GradientButtonType.DISABLE,
                    function: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MakePaymentScreen(
                                    name: widget.profileName,
                                    bookeddate: bookeddate,
                                    costperhour: widget.costperhour,
                                    profileId: widget.profileId,
                                    profileType: widget.profileType,
                                    title: widget.title,
                                  )))
                        })
                : GradientButton(
                    title: "Next",
                    type: GradientButtonType.PAYMENTBUTTON,
                    function: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MakePaymentScreen(
                                    name: widget.profileName,
                                    bookeddate: bookeddate,
                                    costperhour: widget.costperhour,
                                    profileId: widget.profileId,
                                    profileType: widget.profileType,
                                    title: widget.title,
                                  )))
                        }),
          ),
        ],
      ),
    );
  }
}
