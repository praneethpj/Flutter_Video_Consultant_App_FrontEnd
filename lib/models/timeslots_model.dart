import 'dart:convert';

List<TimeSlotModel> jsontoTimeSlotsModel(String str) =>
    List<TimeSlotModel>.from(
        json.decode(str).map((x) => TimeSlotModel.fromJson(x)));

class TimeSlotModel {
  String day;
  String time;
  int activate;

  TimeSlotModel({
    required this.day,
    required this.time,
    required this.activate,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      day: json['day'] ?? "",
      time: json['time'] ?? "",
      activate: json['activate'] ?? 0,
    );
  }

  Map<String, dynamic> asMap() {
    return {
      'day': day,
      'time': time,
      'activate': activate,
    };
  }
}
