import 'dart:convert';

List<CallCommentModel> jsontoCallCommentModel(String str) =>
    List<CallCommentModel>.from(
        json.decode(str).map((x) => CallCommentModel.fromJson(x)));

class CallCommentModel {
  int id;
  String professionaluserId;
  String calluserId;
  String starttime;
  String endtime;
  String rating;
  String comments;
  int activate;
  DateTime createdAt;
  DateTime updatedAt;

  CallCommentModel({
    required this.id,
    required this.professionaluserId,
    required this.calluserId,
    required this.starttime,
    required this.endtime,
    required this.rating,
    required this.comments,
    required this.activate,
    required this.createdAt,
    required this.updatedAt,
  });
  factory CallCommentModel.fromJson(Map<String, dynamic> json) {
    return CallCommentModel(
      id: json['id'],
      professionaluserId: json['professionaluserId'],
      calluserId: json['calluserId'],
      starttime: json['starttime'],
      endtime: json['endtime'],
      rating: json['rating'],
      comments: json['comments'],
      activate: json['activate'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
