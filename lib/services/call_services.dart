import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:timetalk/constants/ApiConstants.dart';
import 'package:timetalk/models/auth_model.dart';
import 'package:timetalk/models/book_professional_model.dart';
import 'package:timetalk/models/call_feedback_model.dart';
import 'package:timetalk/models/call_model.dart';
import 'package:timetalk/screens/authentication_screen.dart';
import 'package:timetalk/screens/video_call/call_feedback_screen.dart';

import '../models/appointed_call_model.dart';
import '../models/call_comment_mode.dart';

var domain = ApiConstants.clouddomain;

class CallService {
  final box = GetStorage();
  Future<List<CallModel>> checkAvaialbleCalls() async {
    var client = Client();

    var httpResponse = await client.post(
      Uri.parse("$domain/api/checkcalls"),
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );
    if (httpResponse.statusCode == 200) {
      print(httpResponse.body);
      var httpResult = json.decode(httpResponse.body);
      //  print("RR ${httpResult['result'][0]}");
      List<CallModel> callmodel =
          jsontoCallModel(json.encode(httpResult['result']));

      return callmodel;
    } else {
      return List.empty();
    }
  }

  Future<void> updateAvaialbleCalls(int id) async {
    var client = Client();
    print("updateAvaialbleCalls id ${id}");

    Map data = {'id': id};
    var _body = json.encode(data);
    var httpResponse = await client.put(
      Uri.parse("$domain/api/updatecallstatustoreceived"),
      body: _body,
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );

    var httpResult = json.decode(httpResponse.body);

    print("httpResult['result'] " + json.encode(httpResult['result']));
  }

  Future<void> updateCallFeedback(CallFeedBackModel callFeedBackScreen) async {
    var client = Client();
    print("updateAvaialbleCalls id  ");

    Map data = {
      'starttime': callFeedBackScreen.starttime,
      'endtime': callFeedBackScreen.endtime,
      'talkcount': callFeedBackScreen.talkcount,
      'totalhours': callFeedBackScreen.totalhours,
      'rating': callFeedBackScreen.rating,
      'professionalId': callFeedBackScreen.professionalId,
      'calluserId': callFeedBackScreen.calluserId,
      'comments': callFeedBackScreen.comments
    };
    var _body = json.encode(data);
    var httpResponse = await client.put(
      Uri.parse("$domain/api/call/updateendcall"),
      body: _body,
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );
    print("httpResult['result'] ${httpResponse.statusCode}");
    print("httpResult['result'] ${httpResponse.body}");
  }

  Future<List<AppointedCallModel>> getUpcomingCalls() async {
    var client = Client();

    var httpResponse = await client.get(
      Uri.parse("$domain/api/call/upcomingcalls"),
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );

    var httpResult = json.decode(httpResponse.body);

    List<AppointedCallModel> callmodel =
        jsontoAppointedCallModel(json.encode(httpResult['result']));

    return callmodel;
  }

  Future<List<AppointedCallModel>> getHistoryCalls() async {
    var client = Client();

    var httpResponse = await client.get(
      Uri.parse("$domain/api/call/historycalls"),
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );

    var httpResult = json.decode(httpResponse.body);
    print("httpResultgetHistoryCalls ${httpResult}");
    List<AppointedCallModel> callmodel =
        jsontoAppointedCallModel(json.encode(httpResult['result']));

    return callmodel;
  }

  Future<List<CallCommentModel>> getCommentsCalls(String profileId) async {
    var client = Client();

    var httpResponse = await client.get(
      Uri.parse("$domain/api/call/comment/${profileId}"),
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );
    print("httpResponse.body ${httpResponse.body}");
    var httpResult = json.decode(httpResponse.body);

    List<CallCommentModel> callmodel =
        jsontoCallCommentModel(json.encode(httpResult['result']));

    return callmodel;
  }
}
