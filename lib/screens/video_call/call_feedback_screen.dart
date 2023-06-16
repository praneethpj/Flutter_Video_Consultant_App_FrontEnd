import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetalk/models/call_feedback_model.dart';
import 'package:timetalk/services/call_services.dart';

class CallFeedBackScreen extends StatefulWidget {
  int talkcount;
  int talkhours;
  String starttime;
  String endtime;
  String professionalId;
  String callUserId;

  CallFeedBackScreen(
      {super.key,
      required this.talkcount,
      required this.talkhours,
      required this.starttime,
      required this.endtime,
      required this.professionalId,
      required this.callUserId});

  @override
  State<CallFeedBackScreen> createState() => _CallFeedBackScreenState();
}

class _CallFeedBackScreenState extends State<CallFeedBackScreen> {
  CallService callServices = CallService();
  TextEditingController commentEditingController = TextEditingController();

  double _rating = 0;
  bool isValidate = false;

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    if (commentEditingController.text.length > 3) {
      isValidate = true;
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Please add your comment on Consultant",
                style:
                    GoogleFonts.lato(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Did you satisfy with this consultant?",
                style: GoogleFonts.lato(fontSize: 20),
              ),
              Container(
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    _rating += rating;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Do you wish to appoinment this consultant again?",
                style: GoogleFonts.lato(fontSize: 20),
              ),
              Container(
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    _rating += rating;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Do you recomended him to your friends or relatives?",
                style: GoogleFonts.lato(fontSize: 20),
              ),
              Container(
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    _rating += rating;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    hintText: 'Add your feelings',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  maxLines: 2,
                  controller: commentEditingController,
                  style: GoogleFonts.lato(fontSize: 20),
                ),
              ),
              SizedBox(
                width: _width,
                child: commentEditingController.text.length < 3
                    ? ElevatedButton(
                        onPressed: null,
                        child: Text(
                          "I am Done",
                          style: GoogleFonts.lato(fontSize: 20),
                        ))
                    : ElevatedButton(
                        onPressed: () {
                          CallFeedBackModel callFeedBackModel =
                              CallFeedBackModel(
                                  starttime: widget.starttime,
                                  endtime: widget.endtime,
                                  talkcount: widget.talkcount,
                                  totalhours: widget.talkhours,
                                  rating: _rating,
                                  professionalId: widget.professionalId,
                                  calluserId: widget.callUserId,
                                  comments: commentEditingController.text);

                          Get.snackbar('Success', 'Thanks for your comment',
                              titleText: Text("Messages"),
                              duration: Duration(seconds: 5),
                              backgroundColor: Colors.black38,
                              colorText: Colors.white);

                          callServices.updateCallFeedback(callFeedBackModel);
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Get.offNamed('/');
                        },
                        child: Text(
                          "I am Done",
                          style: GoogleFonts.lato(fontSize: 20),
                        )),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    commentEditingController.addListener(updateButtonState);
  }

  @override
  void dispose() {
    commentEditingController.removeListener(updateButtonState);
    commentEditingController.dispose();
    super.dispose();
  }

  void updateButtonState() {
    setState(() {});
  }
}
