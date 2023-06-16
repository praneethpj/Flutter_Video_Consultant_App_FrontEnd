import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetalk/constants/ApiConstants.dart';
import 'package:timetalk/middleware/message_socket_call.dart';
import 'package:timetalk/models/call_comment_mode.dart';
import 'package:timetalk/models/professional_model.dart';
import 'package:timetalk/screens/booking_screen.dart';
import 'package:timetalk/screens/common_widget/gradient_button.dart';
import 'package:timetalk/screens/personal_message/personal_message_screen.dart';
import 'package:timetalk/services/api_service.dart';
import 'package:timetalk/services/call_services.dart';

import '../middleware/user_status_socket.dart';
import 'common_widget/pulse_animation.dart';

class ProfileScreen extends StatefulWidget {
  final int profileId;
  final dynamic costperhour;
  const ProfileScreen(
      {super.key, required this.profileId, required this.costperhour});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

Future<List<ProfessionalModel>> getProfessionals(int id) async {
  print("apiService getAllProfessionals");
  ApiService apiService = ApiService();
  List<ProfessionalModel> pp = await apiService.getProfessionalById(id);

  pp.forEach((element) {
    print("apiService ${element.comments}");
  });

  return pp;
}

class _ProfileScreenState extends State<ProfileScreen> {
  CallService callservice = CallService();
  bool _isOnline = false;
  Future<void> _loadOnlineStatus() async {
    var isOnline = await checkUserOnline(widget.profileId.toString());
    setState(() {
      _isOnline = isOnline;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadOnlineStatus();
  }

  @override
  Widget build(BuildContext context) {
    double innerWidth = MediaQuery.of(context).size.width;
    double innerHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
      child: FutureBuilder(
        future: getProfessionals(widget.profileId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: innerHeight * 0.20,
                    width: innerWidth,
                    color: Colors.blue,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: innerHeight * 0.85,
                    width: innerWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                        color: Colors.white),
                    child: Container(
                      child: Column(children: [
                        SizedBox(
                          height: innerHeight * 0.10,
                        ),
                        Container(
                          height: innerHeight * 0.10,
                          child: Column(children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  snapshot.data![0].name,
                                  style: GoogleFonts.lato(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                PulseAnimation(isOnline: _isOnline),
                              ],
                            ),
                            Text(
                              "@angelinahall",
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: Color.fromARGB(255, 194, 192, 192),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Talk Hours",
                                  style: GoogleFonts.lato(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("${snapshot.data![0].talkCount} h",
                                    style: GoogleFonts.lato(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Rating",
                                  style: GoogleFonts.lato(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                RatingBar.builder(
                                  maxRating: 3,
                                  initialRating: snapshot.data![0].rating,
                                  itemCount: 3,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemBuilder: (context, _) => SizedBox(
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Talk Counts",
                                  style: GoogleFonts.lato(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("${snapshot.data![0].talkCount}",
                                    style: GoogleFonts.lato(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 250,
                              height: 60,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => BookingScreen(
                                                  profileId: widget.profileId,
                                                  costperhour:
                                                      widget.costperhour,
                                                  profileName:
                                                      snapshot.data![0].name,
                                                  profileType: snapshot
                                                      .data![0].typename,
                                                  title:
                                                      snapshot.data![0].title,
                                                )));
                                  },
                                  child: Text(
                                    "Talk to call",
                                    style: GoogleFonts.lato(fontSize: 20),
                                  )),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromARGB(255, 68, 127, 255)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: IconButton(

                                  // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                  icon: FaIcon(FontAwesomeIcons.solidMessage,
                                      color: Color.fromARGB(255, 68, 127, 255)),
                                  onPressed: () {
                                    Get.to(PersonalMessageScreen(
                                        targetUserId:
                                            widget.profileId.toString()));
                                  }),
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "What I am doing",
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: innerWidth,
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 211, 211, 211)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                  child: Text("${snapshot.data![0].comments}")),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "What People Say about me",
                              style:
                                  GoogleFonts.lato(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Column(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: innerWidth,
                              height: innerHeight / 10,
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.only(top: 10),
                              alignment: Alignment.topCenter,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 211, 211, 211)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            FutureBuilder<
                                                List<CallCommentModel>>(
                                              future:
                                                  callservice.getCommentsCalls(
                                                      snapshot.data![0].name),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData &&
                                                    ConnectionState.done ==
                                                        snapshot
                                                            .connectionState) {
                                                  if (snapshot.data!.length ==
                                                      0) {
                                                    return Text(
                                                      "No Comments available",
                                                      style: GoogleFonts.lato(
                                                          color:
                                                              Colors.black26),
                                                    );
                                                  } else {
                                                    return Column(
                                                      children: [
                                                        Text(
                                                          "${snapshot.data![0].createdAt}",
                                                          style:
                                                              GoogleFonts.lato(
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        Text(
                                                          "${snapshot.data![0].comments}",
                                                          style:
                                                              GoogleFonts.lato(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 18),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              innerWidth * 0.45,
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ]),
                    ),
                  ),
                ),
                Positioned(
                  top: innerHeight * 0.0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 60,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          "${ApiConstants.clouddomain}/image/${snapshot.data![0].profileImage}",
                        ),
                        radius: 50,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CircularProgressIndicator(),
              ],
            );
          }
        },
      ),
    ));
  }
}
