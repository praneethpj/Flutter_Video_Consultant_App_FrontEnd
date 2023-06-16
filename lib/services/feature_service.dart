import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:timetalk/constants/ApiConstants.dart';
import 'package:timetalk/models/feature_model.dart';
import 'package:timetalk/models/professonal_type_model.dart';

class FeaturelService {
  final box = GetStorage();

  var domain = ApiConstants.clouddomain;

  Future<List<FeatureModel>> getAllgender() async {
    var client = Client();
    var httpResponse = await client.get(
      Uri.parse("$domain/api/feature/genderlist"),
    );
    if (httpResponse.statusCode == 200) {
      print(httpResponse.body);
      var httpResult = json.decode(httpResponse.body);
      //  print("RR ${httpResult['result'][0]}");
      List<FeatureModel> callmodel =
          jsontoFeatureModel(json.encode(httpResult['result']));

      return callmodel;
    } else {
      return List.empty();
    }
  }

  Future<List<FeatureModel>> getAllcountries() async {
    var client = Client();
    var httpResponse = await client.get(
      Uri.parse("$domain/api/feature/countrylist"),
    );
    if (httpResponse.statusCode == 200) {
      print(httpResponse.body);
      var httpResult = json.decode(httpResponse.body);
      //  print("RR ${httpResult['result'][0]}");
      List<FeatureModel> callmodel =
          jsontoFeatureModel(json.encode(httpResult['result']));

      return callmodel;
    } else {
      return List.empty();
    }
  }

  Future<List<FeatureModel>> getAllexperience() async {
    var client = Client();
    var httpResponse = await client.get(
      Uri.parse("$domain/api/feature/experiencelist"),
    );
    if (httpResponse.statusCode == 200) {
      print(httpResponse.body);
      var httpResult = json.decode(httpResponse.body);
      //  print("RR ${httpResult['result'][0]}");
      List<FeatureModel> callmodel =
          jsontoFeatureModel(json.encode(httpResult['result']));

      return callmodel;
    } else {
      return List.empty();
    }
  }

  Future<List<FeatureModel>> getAllLanguageList() async {
    var client = Client();
    var httpResponse = await client.get(
      Uri.parse("$domain/api/feature/languagelist"),
    );
    if (httpResponse.statusCode == 200) {
      print(httpResponse.body);
      var httpResult = json.decode(httpResponse.body);
      //  print("RR ${httpResult['result'][0]}");
      List<FeatureModel> callmodel =
          jsontoFeatureModel(json.encode(httpResult['result']));

      return callmodel;
    } else {
      return List.empty();
    }
  }

  Future<List<FeatureModel>> getAllPerhourList() async {
    var client = Client();
    var httpResponse = await client.get(
      Uri.parse("$domain/api/feature/perhourchargelist"),
    );
    if (httpResponse.statusCode == 200) {
      print(httpResponse.body);
      var httpResult = json.decode(httpResponse.body);
      print("PERPERHOUR ${httpResult['result'][0]}");
      List<FeatureModel> callmodel =
          jsontoFeatureModel(json.encode(httpResult['result']));

      return callmodel;
    } else {
      return List.empty();
    }
  }

  Future<List<ProfessionalType>> getAllProfessionalType() async {
    var client = Client();
    var httpResponse = await client.get(
      Uri.parse("$domain/api/feature/professionaltype"),
    );
    if (httpResponse.statusCode == 200) {
      print(httpResponse.body);
      var httpResult = json.decode(httpResponse.body);
      //  print("RR ${httpResult['result'][0]}");
      List<ProfessionalType> callmodel =
          jsontoProfessionalTypeModel(json.encode(httpResult['result']));

      return callmodel;
    } else {
      return List.empty();
    }
  }

  Future<List<FeatureModel>> getAllTitleList() async {
    var client = Client();
    var httpResponse = await client.get(
      Uri.parse("$domain/api/feature/getalltitle"),
    );
    if (httpResponse.statusCode == 200) {
      print(httpResponse.body);
      var httpResult = json.decode(httpResponse.body);
      //  print("RR ${httpResult['result'][0]}");
      List<FeatureModel> callmodel =
          jsontoFeatureModel(json.encode(httpResult['result']));

      return callmodel;
    } else {
      return List.empty();
    }
  }

  Future<void> updateAllNotifications() async {
    var client = Client();

    var httpResponse = await client.put(
      Uri.parse("$domain/api/feature/updateallnotifications"),
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );

    //var httpResult = json.decode(httpResponse.body);

    print("httpResult['result'] " + json.encode(httpResponse.body));
  }
}
