import 'dart:convert';

List<FeatureModel> jsontoFeatureModel(String str) => List<FeatureModel>.from(
    json.decode(str).map((x) => FeatureModel.fromJson(x)));

class FeatureModel {
  int id;
  dynamic name;
  int active;

  FeatureModel({
    required this.id,
    required this.name,
    required this.active,
  });

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['id'],
      name: json['name'],
      active: json['active'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeatureModel &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
