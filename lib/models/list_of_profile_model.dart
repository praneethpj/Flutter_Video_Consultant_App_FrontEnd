import 'dart:convert';

List<ListProfessionalModel> jsontoListUserModel(String str) =>
    List<ListProfessionalModel>.from(
        json.decode(str).map((x) => ListProfessionalModel.fromJson(x)));

class ListProfessionalModel {
  int id;
  int userId;
  String name;
  String profileImage;
  String title;
  String country;
  String typeId;

  double rating;
  int totalHours;
  int talkCount;
  String costperhour;
  int approve;
  int activate;
  DateTime createdAt;
  DateTime updatedAt;
  // List<Type> types;
  String titleName;
  String typeName;
  String legalfirstname;
  String legallastname;
  int mobileno;
  String gender;
  String mainlanguage;
  int professionname;
  String experience;
  String currentWorkingAddress;
  String comments;

  ListProfessionalModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.profileImage,
    required this.title,
    required this.country,
    required this.typeId,
    required this.rating,
    required this.totalHours,
    required this.talkCount,
    required this.costperhour,
    required this.approve,
    required this.activate,
    required this.createdAt,
    required this.updatedAt,
    //   required this.types,
    required this.titleName,
    required this.typeName,
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

  factory ListProfessionalModel.fromJson(Map<String, dynamic> json) {
    // var typesList = json['types'] as List;
    // List<Type> types =
    //     typesList.map((typeJson) => Type.fromJson(typeJson)).toList();

    return ListProfessionalModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      profileImage: json['profileimage'],
      title: json['titleName'],
      country: json['countryName'],
      typeId: json['typeName'],
      rating: json['rating'].toDouble(),
      totalHours: json['totalhours'],
      talkCount: json['talkcount'],
      costperhour: json['costperhour'],
      legalfirstname: json['legalfirstname'],
      legallastname: json['legallastname'],
      mobileno: json['mobileno'],
      titleName: json['titleName'] ?? "",
      typeName: json['typeName'],
      gender: json['gender'],
      mainlanguage: json['languages'],
      professionname: json['professionname'],
      experience: json['experiences'] ?? "",
      currentWorkingAddress: json['currentworkingaddress'] ?? "",
      comments: json['comments'] ?? "",
      approve: json['approve'],
      activate: json['activate'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      //  types: types,
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
