import 'dart:convert';

List<CallModel> jsontoCallModel(String str) =>
    List<CallModel>.from(json.decode(str).map((x) => CallModel.fromJson(x)));

class CallModel {
  int id;
  int userId;
  String title;
  String calldate;
  String calltime;
  int status;

  CallModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.calldate,
    required this.calltime,
    required this.status,
  });

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      calldate: json['calldate'],
      calltime: json['calltime'],
      status: json['status'],
    );
  }
}
