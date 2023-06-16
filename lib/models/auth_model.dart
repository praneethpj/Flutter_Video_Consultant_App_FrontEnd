import 'dart:convert';

AuthModel jsonToAuthModel(String str) => AuthModel.fromJson(json.decode(str));

class AuthModel {
  int id;
  String username;
  String email;
  List roles;
  String accessToken;

  AuthModel(
      {required this.id,
      required this.username,
      required this.email,
      required this.roles,
      required this.accessToken});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    var roles = json['roles'];
    return AuthModel(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        roles: json['roles'],
        accessToken: json['accessToken']);
  }
}
