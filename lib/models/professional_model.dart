import 'dart:convert';

List<ProfessionalModel> jsontoUserModel(String str) =>
    List<ProfessionalModel>.from(
        json.decode(str).map((x) => ProfessionalModel.fromJson(x)));

class ProfessionalModel {
  int id;
  int userId;
  String name;
  String profileImage;
  String title;
  int titleid;
  int country;
  int typeId;
  dynamic scheduleId;
  // int documentId;
  double rating;
  int totalHours;
  int talkCount;
  int costperhour;
  int approve;
  int activate;
  DateTime createdAt;
  DateTime updatedAt;
  // List<Type> types;
  String typename;
  String legalfirstname;
  String legallastname;
  int mobileno;
  int gender;
  int mainlanguage;
  int professionname;
  int experience;
  String currentWorkingAddress;
  String comments;

  ProfessionalModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.profileImage,
    required this.title,
    required this.titleid,
    required this.country,
    required this.typeId,
    required this.scheduleId,
    // required this.documentId,
    required this.rating,
    required this.totalHours,
    required this.talkCount,
    required this.costperhour,
    required this.approve,
    required this.activate,
    required this.createdAt,
    required this.updatedAt,
    required this.typename,
    required this.legalfirstname,
    required this.legallastname,
    required this.mobileno,
    required this.gender,
    required this.mainlanguage,
    required this.professionname,
    required this.experience,
    required this.currentWorkingAddress,
    required this.comments,
  });

  factory ProfessionalModel.fromJson(Map<String, dynamic> json) {
    // var typesList = json['types'] as List;
    // List<Type> types =
    //     typesList.map((typeJson) => Type.fromJson(typeJson)).toList();

    return ProfessionalModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      profileImage: json['profileimage'],
      title: json['titleName'] ?? "",
      titleid: json['title'],
      country: json['country'],
      typeId: json['typeId'],
      scheduleId: json['scheduleId'],
      // documentId: json['documentId'],
      rating: json['rating'].toDouble(),
      totalHours: json['totalhours'],
      talkCount: json['talkcount'],
      costperhour: json['costperhour'],
      legalfirstname: json['legalfirstname'],
      legallastname: json['legallastname'],
      mobileno: json['mobileno'],
      gender: json['gender'],
      mainlanguage: json['mainlanguage'],
      professionname: json['professionname'],
      experience: json['experiences'],
      currentWorkingAddress: json['currentworkingaddress'] ?? "",
      comments: json['comments'] ?? "",
      approve: json['approve'],
      activate: json['activate'],
      // titleid: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      typename: json['typename'] ?? "",
    );
  }
}

class Type {
  int id;
  String name;
  int activate;
  DateTime createdAt;
  DateTime updatedAt;

  Type({
    required this.id,
    required this.name,
    required this.activate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      id: json['id'],
      name: json['name'],
      activate: json['activate'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
