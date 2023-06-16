import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:timetalk/models/auth_model.dart';
import 'package:timetalk/models/professional_model.dart';
import 'package:timetalk/models/professonal_type_model.dart';

import '../constants/ApiConstants.dart';
import '../models/chat_message_model.dart';

var domain = ApiConstants.clouddomain;

class MessageService {
  final box = GetStorage();
  Future<List<ProfessionalType>> getAllProfessionalType(
      int id, int dayid, String year, String month, String date) async {
    var client = Client();
    var httpResponse = await client.get(Uri.parse(
        "$domain/api/getProfessionalScheduleById/${id}/${dayid}/${year}/${month}/${date}"));

    var httpResult = json.decode(httpResponse.body);

    return jsontoProfessionalTypeModel(json.encode(httpResult['result']));
  }

  Future<List<ChatMessage>> readAllChatMessages() async {
    var client = Client();

    var httpResponse = await client.get(
      Uri.parse("$domain/api/readallchatmessagesbyuser"),
      headers: {
        'x-access-token': box.read('jwt') ?? "",
        'Content-Type': 'application/json'
      },
    );

    var httpResult = json.decode(httpResponse.body);
    //httpResult.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    print("httpResultreadAllChatMessages ${httpResult}");
    return jsontoChatMessage(json.encode(httpResult));
  }

  Future<List<ChatMessage>> readChatMessagesPerUser(
      String targetrecipientId) async {
    var client = Client();

    var httpResponse = await client.get(
      Uri.parse(
          "$domain/api/readchatmessagesbyrecipientId/${targetrecipientId}"),
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );

    var httpResult = json.decode(httpResponse.body);
    //httpResult.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    print("readChatMessagesPerUser ${httpResult}");
    return jsontoChatMessage(json.encode(httpResult));
  }
}
