import 'dart:convert';

List<ProfessionalType> jsontoProfessionalTypeModel(String str) =>
    List<ProfessionalType>.from(
        json.decode(str).map((x) => ProfessionalType.fromJson(x)));

class ProfessionalType {
  int id;
  String name;
  int activate;
  String imagepath;
  DateTime createdAt;
  DateTime updatedAt;

  ProfessionalType({
    required this.id,
    required this.name,
    required this.activate,
    required this.imagepath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfessionalType.fromJson(Map<String, dynamic> json) {
    return ProfessionalType(
      id: json['id'],
      name: json['name'],
      activate: json['activate'],
      imagepath: json['imagepath'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfessionalType &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      imagepath.hashCode ^
      activate.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
