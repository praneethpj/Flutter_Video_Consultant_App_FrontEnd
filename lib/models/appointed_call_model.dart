import 'dart:convert';

List<AppointedCallModel> jsontoAppointedCallModel(String str) =>
    List<AppointedCallModel>.from(
        json.decode(str).map((x) => AppointedCallModel.fromJson(x)));

class AppointedCallModel {
  final int id;
  final String title;
  final int userId;
  final DateTime calldate;
  final String calltime;
  final int status;
  final String paymentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointedCallModel({
    required this.id,
    required this.title,
    required this.userId,
    required this.calldate,
    required this.calltime,
    required this.status,
    required this.paymentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointedCallModel.fromJson(Map<String, dynamic> json) {
    return AppointedCallModel(
      id: json['id'],
      title: json['title'] ?? "",
      userId: json['userId'] ?? 0,
      calldate: DateTime.parse(json['calldate']),
      calltime: json['calltime'],
      status: json['status'],
      paymentId: json['paymentId'] ?? "0",
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'userId': userId,
      'calldate': calldate.toIso8601String(),
      'calltime': calltime,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
