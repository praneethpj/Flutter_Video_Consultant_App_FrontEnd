import 'dart:convert';

List<ScheduleModel> jsontoScheduleModel(String str) => List<ScheduleModel>.from(
    json.decode(str).map((x) => ScheduleModel.fromJson(x)));

class ScheduleModel {
  int id;
  String day;
  String time;
  int available;

  ScheduleModel({
    required this.id,
    required this.day,
    required this.time,
    required this.available,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],
      day: json['day'],
      time: json['time'],
      available: json['available'],
    );
  }
}
