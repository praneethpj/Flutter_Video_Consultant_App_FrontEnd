import 'dart:convert';

BookProfessionalModel jsontoBookProfessionalModel(String str) =>
    BookProfessionalModel.fromJson(json.decode(str));

class BookProfessionalModel {
  int userId;
  int clientId;
  int scheduleId;
  String dateval;
  String time;

  BookProfessionalModel({
    required this.userId,
    required this.clientId,
    required this.scheduleId,
    required this.dateval,
    required this.time,
  });

  factory BookProfessionalModel.fromJson(Map<String, dynamic> json) {
    return BookProfessionalModel(
      userId: json['userId'],
      clientId: json['clientId'],
      time: json['time'],
      scheduleId: json['scheduleId'],
      dateval: json['dateval'],
    );
  }
}
