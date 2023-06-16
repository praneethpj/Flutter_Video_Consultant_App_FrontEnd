import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:timetalk/constants/ApiConstants.dart';
import 'package:timetalk/models/apply_as_profession.model.dart';
import 'package:timetalk/models/list_of_profile_model.dart';
import 'package:timetalk/models/professional_model.dart';
import 'package:timetalk/models/professonal_type_model.dart';
import 'package:timetalk/screens/user_profile_dashboard/apply_as_profession.dart';

import '../models/timeslots_model.dart';

class ProfessionalService {
  final box = GetStorage();

  var domain = ApiConstants.clouddomain;

  Future uploadgovemenrId(String imageFilePath) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("$domain/api/uploadgovermentid"));
    int id = box.read("id");
    String username = box.read("username");
    final httpImage = await http.MultipartFile.fromPath(
      'govermentid_img',
      imageFilePath,
      filename: '${box.read("id")}_govermentid.jpg',
    );

    request.headers['x-access-token'] = box.read('jwt');
    request.files.add(httpImage);
    request.fields['username'] = username;
    request.fields['id'] = id.toString();

    var res = await request.send();
    print("resstatus ${res.statusCode}  ");
    return res.statusCode;
  }

  Future uploadHighestQualification(String imageFilePath) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("$domain/api/uploadhighestqualification"));
    int id = box.read("id");
    String username = box.read("username");
    final httpImage = await http.MultipartFile.fromPath(
      'highestQualification_img',
      imageFilePath,
      filename: '${box.read("id")}_highestqualification.jpg',
    );

    request.headers['x-access-token'] = box.read('jwt');
    request.files.add(httpImage);
    request.fields['username'] = username;
    request.fields['id'] = id.toString();

    var res = await request.send();
    print("resstatus ${res.statusCode}  ");
    return res.statusCode;
  }

  Future uploadLivePhoto(String imageFilePath) async {
    var request =
        http.MultipartRequest('POST', Uri.parse("$domain/api/uploadlivephoto"));
    int id = box.read("id");
    String username = box.read("username");
    final httpImage = await http.MultipartFile.fromPath(
      'live_img',
      imageFilePath,
      filename: '${box.read("id")}_live_img.jpg',
    );

    request.headers['x-access-token'] = box.read('jwt');
    request.files.add(httpImage);
    request.fields['username'] = username;
    request.fields['id'] = id.toString();

    var res = await request.send();
    print("resstatus ${res.statusCode}  ");
    return res.statusCode;
  }

  Future uploadAppoinmentLetter(String imageFilePath) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("$domain/api/uploadappoinmentletter"));
    int id = box.read("id");
    String username = box.read("username");
    final httpImage = await http.MultipartFile.fromPath(
      'appoinment_img',
      imageFilePath,
      filename: '${box.read("id")}_highestqualification.jpg',
    );

    request.headers['x-access-token'] = box.read('jwt');
    request.files.add(httpImage);
    request.fields['username'] = username;
    request.fields['id'] = id.toString();

    var res = await request.send();
    print("resstatus ${res.statusCode}  ");
    return res.statusCode;
  }

  Future<String> uploadProfessionalPhoto(String imageFilePath) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("$domain/api/uploadprofessionalprofilepic"));
    int id = box.read("id");
    String username = box.read("username");
    final httpImage = await http.MultipartFile.fromPath(
      'professional_img',
      imageFilePath,
      filename: '${box.read("id")}_highestqualification.jpg',
    );

    request.headers['x-access-token'] = box.read('jwt');
    request.files.add(httpImage);
    request.fields['username'] = username;
    request.fields['id'] = id.toString();

    var res = await request.send();
    print("resstatus ${res.statusCode}  ");
    return "${id.toString()}/${id.toString()}_professionalprofile.jpg";
  }

  Future<bool> applyAsProfession(
      ApplyAsProfessionModel applyAsProfession) async {
    var client = Client();
    Map data = {
      'name': applyAsProfession.name,
      'legalfirstname': applyAsProfession.legalfirstname,
      'legallastname': applyAsProfession.legallastname,
      'mobileno': applyAsProfession.mobileno,
      'title': applyAsProfession.title,
      'typeId': applyAsProfession.typeId,
      'gender': applyAsProfession.gender,
      'country': applyAsProfession.country,
      'mainlanguage': applyAsProfession.mainlanguage,
      'professionname': applyAsProfession.professionname,
      'profileimage': applyAsProfession.profilepic,
      'experiences': applyAsProfession.experience,
      'costperhour': applyAsProfession.costperhour,
      "currentworkingaddress": applyAsProfession.currentworkingaddress,
      'comment': applyAsProfession.comment,
    };
    //encode Map to JSON
    var _body = json.encode(data);
    var httpResponse = await client.post(
      Uri.parse("$domain/api/applyprofessional"),
      body: _body,
      headers: {
        "Content-Type": "application/json",
        'x-access-token': box.read('jwt'),
      },
    );
    print("httpResponse.body ${httpResponse.body}");
    if (httpResponse.statusCode == 200) {
      //var httpResult = json.decode(httpResponse.body);
      print(httpResponse.body);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updatesProfession(
      ApplyAsProfessionModel applyAsProfession) async {
    var client = Client();
    Map data = {
      'name': applyAsProfession.name,
      'legalfirstname': applyAsProfession.legalfirstname,
      'legallastname': applyAsProfession.legallastname,
      'mobileno': applyAsProfession.mobileno,
      'title': applyAsProfession.title,
      'typeId': applyAsProfession.typeId,
      'gender': applyAsProfession.gender,
      'country': applyAsProfession.country,
      'mainlanguage': applyAsProfession.mainlanguage,
      'professionname': applyAsProfession.professionname,
      'profileimage': applyAsProfession.profilepic,
      'experiences': applyAsProfession.experience,
      'costperhour': applyAsProfession.costperhour,
      'currentworkingaddress': applyAsProfession.currentworkingaddress,
      'comment': applyAsProfession.comment,
    };
    //encode Map to JSON
    var _body = json.encode(data);
    var httpResponse = await client.post(
      Uri.parse("$domain/api/updateProfessional"),
      body: _body,
      headers: {
        "Content-Type": "application/json",
        'x-access-token': box.read('jwt'),
      },
    );
    print("httpResponse.body ${httpResponse.body}");
    if (httpResponse.statusCode == 200) {
      //var httpResult = json.decode(httpResponse.body);
      print(httpResponse.body);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createSchedule(
      Map<String, Map<String, Map<String, bool>>> schedules) async {
    var client = Client();
    var _body = json.encode(schedules);
    var httpResponse = await client.post(
      Uri.parse("$domain/api/createSchedules"),
      body: _body,
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );
    if (httpResponse.statusCode == 200) {
      print(httpResponse.body);
      var httpResult = json.decode(httpResponse.body);
      //  print("RR ${httpResult['message']}");

      return true;
    }
    return false;
  }

  Future<List<TimeSlotModel>> getTimeSlotByUserAndDayId(int dayid) async {
    var client = Client();

    var httpResponse = await client.get(
      Uri.parse("$domain/api/getschedulesbyuserid/${dayid}"),
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );

    var httpResult = json.decode(httpResponse.body);

    return jsontoTimeSlotsModel(json.encode(httpResult['result']));
  }

  Future<bool> updateTimeSlotByUserAndDayId(
      int dayid, String time, bool activate) async {
    var client = Client();

    Map data = {
      'time': time,
      'day': dayid,
      'activate': activate,
    };
    //encode Map to JSON
    var _body = json.encode(data);

    var httpResponse = await client.put(
      Uri.parse("$domain/api/updateschedulesbyuseridandday"),
      body: _body,
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );
    print("httpResult update activate ${activate}");
    var httpResult = json.decode(httpResponse.body);
    print("httpResult update ${httpResult}");
    if (httpResponse.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<ListProfessionalModel>> getAllProfessionalByTypeId(
      int typeId, int limit, int offset) async {
    var client = Client();

    var httpResponse = await client.get(
      Uri.parse("$domain/api/getProfessionalsTypeById/$typeId/$offset/$limit"),
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );
    print("httpResponse.body ${httpResponse.body}");
    var httpResult = json.decode(httpResponse.body);

    List<ListProfessionalModel> callmodel =
        jsontoListUserModel(json.encode(httpResult['result']));

    return callmodel;
  }

  Future<List<ListProfessionalModel>> getAllProfessionalBySearchText(
      String searchtext, int limit, int offset) async {
    var client = Client();

    var httpResponse = await client.get(
      Uri.parse(
          "$domain/api/getProfessionalsBySearchText/$searchtext/$offset/$limit"),
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );
    print("httpResponse.body ${httpResponse.body}");
    var httpResult = json.decode(httpResponse.body);

    List<ListProfessionalModel> callmodel =
        jsontoListUserModel(json.encode(httpResult['result']));

    return callmodel;
  }

  Future<List<ListProfessionalModel>> getAllProfessionalByAllTypeAll(
      int limit, int offset) async {
    var client = Client();

    var httpResponse = await client.get(
      Uri.parse("$domain/api/getProfessionalsAllTypeByAllId/$offset/$limit"),
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );
    print("httpResponse.body ${httpResponse.body}");
    var httpResult = json.decode(httpResponse.body);

    List<ListProfessionalModel> callmodel =
        jsontoListUserModel(json.encode(httpResult['result']));

    return callmodel;
  }

  Future<void> resetAllTimeSlots() async {
    var client = Client();

    var httpResponse = await client.delete(
      Uri.parse("$domain/api/resetAllScheduleByUserId"),
      headers: {
        'x-access-token': box.read('jwt'),
        'Content-Type': 'application/json'
      },
    );
  }
}
