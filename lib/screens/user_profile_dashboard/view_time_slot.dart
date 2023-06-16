import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetalk/helpers/DataHelper.dart';
import 'package:timetalk/models/timeslots_availability.dart';
import 'package:timetalk/models/timeslots_model.dart';
import 'package:timetalk/screens/user_profile_dashboard/time_slot_widget/labeled_cupertino_switch.dart';
import 'package:timetalk/services/api_service.dart';

import '../../services/professional_service.dart';

class ViewTimeSlots extends StatefulWidget {
  const ViewTimeSlots({super.key});

  @override
  State<ViewTimeSlots> createState() => _ViewTimeSlotsState();
}

class _ViewTimeSlotsState extends State<ViewTimeSlots> {
  ProfessionalService professionalService = ProfessionalService();

  FToast fToast = FToast();

  List<TimeSlotModel> _timeRanges = [];
  Map<String, dynamic> keyValueMap = {};
  final List<bool> _selections = List.generate(7, (_) => false);
  String sheetname = "Monday";
  int sheetid = 1;

  int numberOfSlots = 0;
  int numberOfDays = 0;
  List<int> selectedDayList = [];

  bool isLoading = false;

  Future<List<TimeSlotModel>> getTimeSlotsByDayId(int dayid) async {
    _timeRanges = await professionalService.getTimeSlotByUserAndDayId(dayid);

    _switchValues = List.generate(_timeRanges.length, (_) => false);
    _timeRanges.asMap().forEach((index, element) {
      _switchValues![index] = element.activate == 1;
    });
    setState(() {});
    return _timeRanges;
  }

  List<Pair<int, List<Pair<String, String>>>> daySlotTimes = [
    Pair(0, []),
    Pair(1, []),
    Pair(2, []),
    Pair(3, []),
    Pair(4, []),
    Pair(5, []),
    Pair(6, []),
  ];

  @override
  void initState() {
    super.initState();
    fToast!.init(context);
    getTimeSlotsByDayId(1);
    _isCheckedList[0] = !_isCheckedList[0];

    Future.delayed(Duration(seconds: 1), () {
      daySelection("Monday", 1);
    });
    setState(() {});
  }

  List<bool>? _switchValues;
  List<bool> _isCheckedList = [true, true, true, true, true, true, true];

  Future<void> _handleSwitchValueChanged(
      int index, bool value, String label) async {
    setState(() {
      isLoading = true;
    });
    print("label ${label} value ${value} ${keyValueMap.length}");

    bool response = await professionalService.updateTimeSlotByUserAndDayId(
        sheetid, label, value);

    if (response) {
      //showToast("${label} updated");
      DataHelper.showInformationMessage(
          "Updated", "Successfully Updated the day");
    } else {
      DataHelper.showInformationMessage(
          "Error", "Some thing went to wrong please try again later");
    }
    setState(() {
      isLoading = false;
    });
  }

  Map<String, Map<String, Map<String, bool>>> generateJsonData(
    List<Pair<int, List<Pair<String, String>>>> daySlotTimes,
  ) {
    Map<String, Map<String, Map<String, bool>>> json = {};

    for (var pair in daySlotTimes) {
      int day = pair.first;
      List<Pair<String, String>> slotTimes = pair.second;

      Map<String, Map<String, bool>> dayAvailability = {};

      for (var slotTime in slotTimes) {
        String startTime = slotTime.first;
        String endTime = slotTime.second;
        String slotKey = '$startTime-$endTime';

        dayAvailability[slotKey] = {"availability": true};
      }

      json[day.toString()] = dayAvailability;
    }

    return json;
  }

  showToast(String msg) {
    fToast.showToast(
        child: Text("$msg"),
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 234, 170),
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                msg,
                style: GoogleFonts.lato(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            top: 100,
            left: 80.0,
          );
        });
  }

  void daySelection(String day, int dayno) {
    sheetname = day;
    sheetid = dayno;
    getTimeSlotsByDayId(sheetid);
    // if (!selectedDayList.contains(dayno)) {
    //   selectedDayList.add(dayno);
    // }
    setState(() {});
  }

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text("Do you like to reset all time slot? This cannot be undo"),
      actions: [
        ElevatedButton(
          child: Text("Yes"),
          onPressed: () {
            // execute function here
            professionalService.resetAllTimeSlots();
            Navigator.of(context).pop();
            Get.toNamed("/");
          },
        ),
        ElevatedButton(
          child: Text("No"),
          onPressed: () {
            // dismiss dialog
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('View your availability'),
      ),
      body: SafeArea(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            _isCheckedList[0] = !_isCheckedList[0];
                            daySelection("Monday", 1);
                          },
                          child: Text("Mo")),
                      ElevatedButton(
                        onPressed: () {
                          daySelection("Tueseday", 2);
                        },
                        child: Text("Tu"),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            daySelection("Wednsday", 3);
                          },
                          child: Text("We")),
                      ElevatedButton(
                          onPressed: () {
                            daySelection("Thurday", 4);
                          },
                          child: Text("Th")),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            daySelection("Friday", 5);
                          },
                          child: Text("Fr")),
                      ElevatedButton(
                          onPressed: () {
                            daySelection("Saturday", 6);
                          },
                          child: Text("Sa")),
                      ElevatedButton(
                          onPressed: () {
                            daySelection("Sunday", 0);
                          },
                          child: Text("Su")),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       daySelection("All", 7);
                      //     },
                      //     child: Text("All")),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "${sheetname} Sheet",
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Time Slot')),
                          DataColumn(label: Text('Availability')),
                        ],
                        rows: _timeRanges.asMap().entries.map((entry) {
                          final index = entry.key;
                          final timeRange = entry.value;
                          return DataRow(cells: [
                            DataCell(Text(
                              timeRange.time,
                              style: GoogleFonts.lato(fontSize: 20),
                            )),
                            DataCell(
                              CupertinoSwitch(
                                value: _switchValues![index],
                                onChanged: (value) {
                                  setState(() {
                                    _switchValues![index] = value;
                                  });
                                  _handleSwitchValueChanged(
                                      index, value, "${timeRange.time!}");
                                },
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                        "Once you are updating, that affect your future availability"),
                  ),
                  SizedBox(
                    width: _width,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          showAlertDialog(context);
                        },
                        child: Text("Reset all time slots")),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
      ),
    );
  }
}

class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);
}
