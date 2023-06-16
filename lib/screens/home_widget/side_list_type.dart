import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timetalk/constants/CustomColors.dart';
import 'package:timetalk/middleware/user_status_socket.dart';
import 'package:timetalk/models/professional_model.dart';
import 'package:timetalk/screens/authentication_screen.dart';
import 'package:timetalk/screens/common_widget/custom_stext.dart';
import 'package:http/http.dart' as http;
import 'package:timetalk/screens/common_widget/pulse_animation.dart';
import 'package:timetalk/screens/consultants_list_screen.dart';
import 'package:timetalk/screens/profile_screen.dart';
import 'package:timetalk/services/api_service.dart';

import '../../constants/ApiConstants.dart';
import '../../models/list_of_profile_model.dart';
import 'custom_profile_card.dart';

class SideScrollProfessionals extends StatefulWidget {
  const SideScrollProfessionals({super.key});

  @override
  State<SideScrollProfessionals> createState() => _SideScrollProfessionals();
}

class _SideScrollProfessionals extends State<SideScrollProfessionals> {
  final box = GetStorage();
  int _currentPage = 0;
  int _itemsPerPage = 10;

  Future<List<ListProfessionalModel>> getAllProfessionals() async {
    print("apiService getAllProfessionals");
    ApiService apiService = ApiService();
    List<ListProfessionalModel> pp = await apiService.getAllProfessional();
    pp.forEach((element) {
      print("apiService name ${element.name}");
    });

    return pp;
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    String? auth = box.read('jwt');
    return Container(
      height: _height / 4,
      child: FutureBuilder<List<ListProfessionalModel>>(
        future: getAllProfessionals(),
        builder: (context, snapshot) {
          if (ConnectionState.done == snapshot.connectionState &&
              snapshot.hasData) {
            List<ListProfessionalModel> professionals = snapshot.data!;
            int pageCount = (professionals.length / _itemsPerPage).ceil();
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: pageCount,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemBuilder: (BuildContext context, int i) =>
                        ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _itemsPerPage,
                      itemBuilder: (BuildContext context, int j) {
                        int index = i * _itemsPerPage + j;
                        if (index >= professionals.length)
                          return SizedBox.shrink();
                        return CustomProfileCard(
                          homepage: true,
                          profileId: professionals[index].userId,
                          costPerHour:
                              double.parse(professionals[index].costperhour),
                          profileImageUrl:
                              "${ApiConstants.clouddomain}/image/${professionals[index].profileImage}",
                          profileName:
                              "${professionals[index].titleName} ${professionals[index].name}",
                          rating: professionals[index].rating,
                          professionalType: professionals[index].typeName,
                        );
                      },
                    ),
                  ),
                ),
                if (pageCount > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                      pageCount,
                      (index) => Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _currentPage == index ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          } else if (ConnectionState.done == snapshot.connectionState &&
              !snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [Text("No professional data has been found")],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [CircularProgressIndicator()],
            );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getAllProfessionals();
    // getList();
  }
}

class SideListType {
  final String title;
  final String image;

  SideListType({required this.title, required this.image});
}
