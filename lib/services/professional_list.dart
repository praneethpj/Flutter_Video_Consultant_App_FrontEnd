import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:timetalk/models/list_of_profile_model.dart';

import '../constants/ApiConstants.dart';

class ProfessionalList {
  final List<ListProfessionalModel> professionals;
  final int currentPage;
  final int lastPage;

  ProfessionalList({
    required this.professionals,
    required this.currentPage,
    required this.lastPage,
  });
}

final box = GetStorage();

var domain = ApiConstants.clouddomain;
Future<ProfessionalList> getAllProfessionalByTypeId(
    int typeId, int page, int limit) async {
  var client = Client();

  var httpResponse = await client.get(
    Uri.parse(
        "$domain/api/getProfessionalsById/${typeId}?page=$page&limit=$limit"),
    headers: {
      'x-access-token': box.read('jwt'),
      'Content-Type': 'application/json'
    },
  );
  print("httpResponse.body ${httpResponse.body}");
  var httpResult = json.decode(httpResponse.body);

  List<ListProfessionalModel> callmodel =
      jsontoListUserModel(json.encode(httpResult['result']));

  int totalCount = httpResult['totalCount'];
  int lastPage = (totalCount / limit).ceil();

  return ProfessionalList(
    professionals: callmodel,
    currentPage: page,
    lastPage: lastPage,
  );
}
