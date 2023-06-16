import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetalk/constants/ApiConstants.dart';
import 'package:timetalk/middleware/user_payment_object.dart';
import 'package:timetalk/screens/authentication/utils/authentication.dart';
import 'package:timetalk/screens/authentication_screen.dart';
import 'package:timetalk/screens/user_profile_dashboard/add_time_slot.dart';
import 'package:timetalk/screens/user_profile_dashboard/apply_as_profession.dart';
import 'package:timetalk/screens/user_profile_dashboard/lable_widget.dart';
import 'package:timetalk/screens/user_profile_dashboard/listofbook_screen/list_of_book_screen.dart';
import 'package:timetalk/screens/user_profile_dashboard/view_profession_info.dart';
import 'package:timetalk/screens/user_profile_dashboard/view_time_slot.dart';

import '../models/professional_model.dart';
import '../services/api_service.dart';

class UserProfileDashboard extends StatefulWidget {
  const UserProfileDashboard({super.key});

  @override
  State<UserProfileDashboard> createState() => _UserProfileDashboardState();
}

class _UserProfileDashboardState extends State<UserProfileDashboard> {
  final box = GetStorage();
  UserPaymentObject userPaymentObject = UserPaymentObject();
  String name = "";

  var apiService = ApiService();

  Future<List<ProfessionalModel>> load() async {
    int id = box.read("id") ?? 0;

    return await apiService.getProfessionalById(id);
  }

  @override
  void initState() {
    super.initState();
    name = box.read("username") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    //load();
    return Scaffold(
      body: LayoutBuilder(
        builder: (p0, p1) {
          double innerWidth = p1.maxHeight;
          double innerHeight = p1.maxHeight;
          return FutureBuilder(
            future: load(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Column(
                  children: [
                    Container(
                      height: innerHeight * 0.20,
                      width: innerWidth,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    box.erase();
                                    userPaymentObject.clear();
                                    // Get.back();
                                    Navigator.of(context).pop();
                                    //Get.to(Authentication());
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          AuthenticationScreen(
                                        isPaymentProcess: false,
                                      ),
                                    ));
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.signOut,
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                height: innerHeight * 0.09,
                                width: innerHeight * 0.09,
                                child: CircleAvatar(
                                  backgroundImage: snapshot.data!.isNotEmpty
                                      ? NetworkImage(
                                          "${ApiConstants.clouddomain}/image/${snapshot.data![0].profileImage}")
                                      : NetworkImage(""),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    FontAwesomeIcons.faceMehBlank,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${name}",
                            style: GoogleFonts.lato(
                                fontSize: 22, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: innerHeight * 0.80,
                        width: innerWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(ListOfBookScreen());
                                },
                                child: LableWidget(
                                  title: "My Call History",
                                  icons: FontAwesomeIcons.clockRotateLeft,
                                ),
                              ),
                              snapshot.data!.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        Get.to(ViewProfessionInfo(
                                          professionalModel:
                                              snapshot.data!.first,
                                        ));
                                      },
                                      child: LableWidget(
                                        title: "View Professional Account",
                                        icons: FontAwesomeIcons.personRifle,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Get.to(ApplyAsProfession());
                                      },
                                      child: LableWidget(
                                        title: "Apply as a Profession",
                                        icons: FontAwesomeIcons.personRifle,
                                      ),
                                    ),
                              snapshot.hasData && snapshot.data!.isNotEmpty
                                  ? snapshot.data![0].activate == 0
                                      ? GestureDetector(
                                          onTap: () {
                                            Get.to(AddTimeSlots());
                                          },
                                          child: LableWidget(
                                            title: "Add Time Slot",
                                            icons: FontAwesomeIcons.calendar,
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            Get.to(ViewTimeSlots());
                                          },
                                          child: LableWidget(
                                            title: "View Time Slot",
                                            icons:
                                                FontAwesomeIcons.calendarDays,
                                          ),
                                        )
                                  : Text(""),
                              // snapshot.data!.length != 0
                              //     ? GestureDetector(
                              //         onTap: () {
                              //           Get.to(ViewTimeSlots());
                              //         },
                              //         child: LableWidget(
                              //           title: "Update my Status",
                              //           icons: FontAwesomeIcons.pizzaSlice,
                              //         ),
                              //       )
                              //     : Text(""),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasData == false) {
                return Column(
                  children: [
                    Container(
                      height: innerHeight * 0.20,
                      width: innerWidth,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    box.erase();
                                    userPaymentObject.clear();
                                    // Get.back();
                                    Navigator.of(context).pop();
                                    //Get.to(Authentication());
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          AuthenticationScreen(
                                        isPaymentProcess: false,
                                      ),
                                    ));
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.signOut,
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                height: innerHeight * 0.09,
                                width: innerHeight * 0.09,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(""),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    FontAwesomeIcons.faceMehBlank,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${name}",
                            style: GoogleFonts.lato(
                                fontSize: 22, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: innerHeight * 0.80,
                        width: innerWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: Column(
                            children: [
                              LableWidget(
                                title: "Change my Profile",
                                icons: FontAwesomeIcons.faceGrin,
                              ),
                              LableWidget(
                                title: "My Call History",
                                icons: FontAwesomeIcons.clockRotateLeft,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(ApplyAsProfession());
                                },
                                child: LableWidget(
                                  title: "Apply as a Profession",
                                  icons: FontAwesomeIcons.personRifle,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(AddTimeSlots());
                                },
                                child: LableWidget(
                                  title: "Add Time Slot",
                                  icons: FontAwesomeIcons.calendar,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(ViewTimeSlots());
                                },
                                child: LableWidget(
                                  title: "View Time Slot",
                                  icons: FontAwesomeIcons.calendarDays,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(ViewTimeSlots());
                                },
                                child: LableWidget(
                                  title: "Update my Status",
                                  icons: FontAwesomeIcons.pizzaSlice,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        },
      ),
    );
  }
}
