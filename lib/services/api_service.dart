import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:timetalk/models/auth_model.dart';
import 'package:timetalk/models/professional_model.dart';
import 'package:timetalk/models/professonal_type_model.dart';

import '../constants/ApiConstants.dart';
import '../models/chat_message_model.dart';
import '../models/list_of_profile_model.dart';
import '../models/schedule_model.dart';

var domain = ApiConstants.clouddomain;

class ApiService {
  Future<List<ListProfessionalModel>> getAllProfessional() async {
    var client = Client();
    var httpResponse =
        await client.get(Uri.parse("$domain/api/getAllProfessional"));

    var httpResult = json.decode(httpResponse.body);
    print("httpResult['result'] ddd ${httpResult['result']}");
    return jsontoListUserModel(json.encode(httpResult['result']));
  }

  Future<List<ProfessionalModel>> getProfessionalById(int id) async {
    var client = Client();

    var httpResponse =
        await client.get(Uri.parse("$domain/api/getProfessionalById/${id}"));

    var httpResult = json.decode(httpResponse.body);
    print("httpResult['result'] ${httpResult['result']} ${id}");
    var professionalmodel = jsontoUserModel(json.encode(httpResult['result']));
    return professionalmodel;
  }

  Future<List<ScheduleModel>> getScheduleByProfileIdAndDayId(
      int id, int dayid, String year, String month, String date) async {
    var client = Client();
    var httpResponse = await client.get(Uri.parse(
        "$domain/api/getProfessionalScheduleById/${id}/${dayid}/${year}/${month}/${date}"));

    print(
        "Domain ${"$domain/api/getProfessionalScheduleById/${id}/${dayid}/${year}/${month}/${date}"}");
    var httpResult = json.decode(httpResponse.body);

    return jsontoScheduleModel(json.encode(httpResult['result']));
  }

  Future<AuthModel> signIn(String username, String password) async {
    try {
      var client = Client();
      Map data = {'username': username, 'password': password};
      //encode Map to JSON
      var _body = json.encode(data);
      var httpResponse = await client.post(
        Uri.parse("$domain/api/auth/signin"),
        body: _body,
        headers: {"Content-Type": "application/json"},
      );
      print("httpResponse auth ${httpResponse.body}");
      if (httpResponse.statusCode == 200) {
        //var httpResult = json.decode(httpResponse.body);

        return jsonToAuthModel(httpResponse.body);
      } else {
        return AuthModel(
            accessToken: "", email: "", id: -1, roles: [], username: "");
      }
    } catch (e) {
      print("Error ${e}");
    }
    return AuthModel(
        accessToken: "", email: "", id: -1, roles: [], username: "");
  }

  Future<AuthModel> signUp(
      String email, String username, String password) async {
    var client = Client();
    Map data = {'email': email, 'username': username, 'password': password};
    //encode Map to JSON
    var _body = json.encode(data);
    var httpResponse = await client.post(
      Uri.parse("$domain/api/auth/signup"),
      body: _body,
      headers: {"Content-Type": "application/json"},
    );
    print("httpResponse.body ${httpResponse.body} ${httpResponse.statusCode}");
    if (httpResponse.statusCode == 200) {
      //var httpResult = json.decode(httpResponse.body);

      return AuthModel(
          accessToken: "200", email: "", id: -1, roles: [], username: "");
    } else {
      Get.snackbar('Error', httpResponse.body,
          duration: Duration(seconds: 5),
          backgroundColor: Colors.black38,
          colorText: Colors.white);
      return AuthModel(
          accessToken: "",
          email: httpResponse.body,
          id: -1,
          roles: [],
          username: httpResponse.statusCode.toString());
    }
  }
}
