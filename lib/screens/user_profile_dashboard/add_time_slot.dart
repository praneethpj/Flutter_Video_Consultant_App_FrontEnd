import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetalk/models/timeslots_availability.dart';
import 'package:timetalk/models/timeslots_model.dart';
import 'package:timetalk/screens/user_profile_dashboard/time_slot_widget/labeled_cupertino_switch.dart';
import 'package:timetalk/services/api_service.dart';

import '../../services/professional_service.dart';

class AddTimeSlots extends StatefulWidget {
  const AddTimeSlots({super.key});

  @override
  State<AddTimeSlots> createState() => _AddTimeSlotsState();
}

class _AddTimeSlotsState extends State<AddTimeSlots> {
  ProfessionalService professionalService = ProfessionalService();
  int _timeSlot = 15;
  List<Map<String, String>> _timeRanges = [];
  Map<String, dynamic> keyValueMap = {};
  final List<bool> _selections = List.generate(7, (_) => false);
  String sheetname = "Monday";
  int sheetid = 1;

  int numberOfSlots = 0;
  int numberOfDays = 0;
  List<int> selectedDayList = [];

  bool mon = true;
  bool tue = false;
  bool wed = false;
  bool thu = false;
  bool fri = false;
  bool sat = false;
  bool sun = false;

  Future<List<TimeSlotModel>> getTimeSlotsByDayId(int dayid) async {
    List<TimeSlotModel> timeslot =
        await professionalService.getTimeSlotByUserAndDayId(dayid);
    return timeslot;
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
    _generateTimeRanges();
  }

  List<bool>? _switchValues;
  List<bool> _isCheckedList = [true, true, true, true, true, true, true];

  void _generateTimeRanges() {
    int numOfSlots = (24 * 60) ~/ _timeSlot;
    List<String> startTimes = List.generate(numOfSlots, (index) {
      int minutes = index * _timeSlot;
      int hours = minutes ~/ 60;
      minutes = minutes % 60;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    });
    List<String> endTimes = startTimes.sublist(1)..add('24:00');
    _timeRanges = List.generate(numOfSlots, (index) {
      return {
        'Start Time': startTimes[index],
        'End Time': endTimes[index],
      };
    });
    for (int i = 0; i < _timeRanges.length; i++) {
      if (i < _timeRanges.length - 1) {
        int minutes = int.parse(_timeRanges[i]['End Time']!.split(':')[1]) + 5;
        int hours = int.parse(_timeRanges[i]['End Time']!.split(':')[0]);
        if (minutes >= 60) {
          minutes -= 60;
          hours += 1;
        }
        _timeRanges[i + 1]['Start Time'] =
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
      }
    }
    _switchValues = List.generate(_timeRanges.length, (_) => false);
  }

  bool _switchValue = true;
  void _handleSwitchValueChanged(int index, bool value, String label) {
    if (value == true) {
      numberOfSlots = numberOfSlots + 1;
      keyValueMap.putIfAbsent(label, () => value);
      print("label ${label} value ${value} ${keyValueMap.length}");

      List<String> times = label.split("-");

      insertSlotTime(daySlotTimes, sheetid, Pair(times[0], times[1]));
    }
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

  void insertSlotTime(List<Pair<int, List<Pair<String, String>>>> daySlotTimes,
      int day, Pair<String, String> slotTime) {
    for (var i = 0; i < daySlotTimes.length; i++) {
      if (daySlotTimes[i].first == day) {
        daySlotTimes[i].second.add(slotTime);
        break;
      }
    }
  }

  Future<void> save() async {
    final jsonData = generateJsonData(daySlotTimes);
    bool response = await professionalService.createSchedule(jsonData);
    print("jsonData ${jsonData} response ${response}");
    Navigator.of(context).pop();
    Get.toNamed("/");
  }

  void daySelection(String day, int dayno) {
    sheetname = day;
    sheetid = dayno;
    if (!selectedDayList.contains(dayno)) {
      selectedDayList.add(dayno);
    }
    _generateTimeRanges();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup your availability'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DropdownButtonFormField<int>(
                value: _timeSlot,
                items: [
                  DropdownMenuItem(value: 15, child: Text('15 minutes')),
                  DropdownMenuItem(value: 30, child: Text('30 minutes')),
                  DropdownMenuItem(value: 60, child: Text('60 minutes')),
                ],
                onChanged: (value) {
                  setState(() {
                    _timeSlot = value!;
                    _generateTimeRanges();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Time Slot',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                mon
                    ? ElevatedButton(
                        onPressed: null,
                        child: Row(
                          children: [Text("Mo")],
                        ))
                    : ElevatedButton(
                        onPressed: () {
                          _isCheckedList[0] = !_isCheckedList[0];
                          daySelection("Monday", 1);
                          setState(() {
                            mon = true;
                          });
                        },
                        child: Row(
                          children: [Text("Mo"), Icon(Icons.check)],
                        )),
                tue
                    ? ElevatedButton(
                        onPressed: null,
                        child: Text("Tu"),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            tue = true;
                          });
                          daySelection("Tueseday", 2);
                        },
                        child: Text("Tu"),
                      ),
                wed
                    ? ElevatedButton(onPressed: null, child: Text("We"))
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            wed = true;
                          });
                          daySelection("Wednsday", 3);
                        },
                        child: Text("We")),
                thu
                    ? ElevatedButton(onPressed: null, child: Text("Th"))
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            thu = true;
                          });
                          daySelection("Thurday", 4);
                        },
                        child: Text("Th")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                fri
                    ? ElevatedButton(onPressed: null, child: Text("Fr"))
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            fri = true;
                          });
                          daySelection("Friday", 5);
                        },
                        child: Text("Fr")),
                sat
                    ? ElevatedButton(onPressed: null, child: Text("Sa"))
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            sat = true;
                          });
                          daySelection("Saturday", 6);
                        },
                        child: Text("Sa")),
                sun
                    ? ElevatedButton(onPressed: null, child: Text("Su"))
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            sun = true;
                          });
                          daySelection("Sunday", 0);
                        },
                        child: Text("Su")),
                ElevatedButton(
                    onPressed: () {
                      mon = true;
                      tue = false;
                      wed = false;
                      thu = false;
                      fri = false;
                      sat = false;
                      sun = false;
                    },
                    child: Text("Reset")),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "${sheetname} Sheet",
                style:
                    GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 25),
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
                    DataColumn(label: Text('Start Time')),
                    DataColumn(label: Text('End Time')),
                    DataColumn(label: Text('Availability')),
                  ],
                  rows: _timeRanges.asMap().entries.map((entry) {
                    final index = entry.key;
                    final timeRange = entry.value;
                    return DataRow(cells: [
                      DataCell(Text(timeRange['Start Time']!)),
                      DataCell(Text(timeRange['End Time']!)),
                      DataCell(
                        LabeledCupertinoSwitch(
                          value: _switchValues![index],
                          label:
                              "${timeRange['Start Time']!}-${timeRange['End Time']!}",
                          onChanged: (value) {
                            setState(() {
                              _switchValues![index] = value;
                            });
                            _handleSwitchValueChanged(index, value,
                                "${timeRange['Start Time']!}-${timeRange['End Time']!}");
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
                  "Once you are saving, you will open to reach client at your availability days and times"),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                width: _width,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      save();
                    },
                    child: Text("Save My Time slotes")))
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
