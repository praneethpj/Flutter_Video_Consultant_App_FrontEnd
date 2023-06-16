import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:timetalk/constants/ApiConstants.dart';
import 'package:timetalk/models/auth_model.dart';
import 'package:timetalk/models/book_professional_model.dart';
import 'package:timetalk/models/payment.dart';

var domain = ApiConstants.clouddomain;

class PaymentService {
  final box = GetStorage();
  Future<BookProfessionalModel> bookaprofessional(
      int userId,
      int scheduleId,
      String dateval,
      String time,
      String realDate,
      String paypaltoken,
      double platformfee,
      double userfees,
      double taxfees,
      String totalfees) async {
    var client = Client();
    Map data = {
      'userId': userId,
      'clientId': box.read("id"),
      'clientusername': box.read("username"),
      'scheduleId': scheduleId,
      'dateval': dateval,
      'time': time,
      'realdate': realDate,
      'paypaltoken': paypaltoken,
      'userfee': userfees,
      'platformfee': platformfee,
      'taxfee': taxfees,
      'totalfee': totalfees
    };

    final headers = {
      'x-access-token': box.read('jwt'),
      'Content-Type': 'application/json',
    };
    //encode Map to JSON
    var _body = json.encode(data);
    var httpResponse = await client.post(
      Uri.parse("$domain/api/bookaprofessional"),
      body: _body,
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );

    if (httpResponse.statusCode == 200) {
      print(httpResponse.body);
      var httpResult = json.decode(httpResponse.body);
      return jsontoBookProfessionalModel(json.encode(httpResult['result']));
    } else {
      return BookProfessionalModel(
          clientId: 0, dateval: "", scheduleId: 0, time: "", userId: 0);
    }
  }

  Future<Payment> getPaymentsById(String id) async {
    var client = Client();

    var httpResponse = await client.post(
      Uri.parse("$domain/api/getPaymentsById/${id}"),
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );

    // if (httpResponse.statusCode == 200) {
    print(httpResponse.body);
    var httpResult = json.decode(httpResponse.body);
    print("getPaymentsById ${httpResult['result'][0]}");
    Payment callmodel = jsontoPaymentModel(json.encode(httpResult['result']));

    return callmodel;
    //  }
    // } else {
    //   return List.empty();
    // }
  }
}
