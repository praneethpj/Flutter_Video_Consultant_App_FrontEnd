import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:timetalk/screens/video_call/video_call_screen.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

class IncomingCallScreen extends StatefulWidget {
  String title;
  String timeduration;

  /// Creates a call page with given channel name.
  IncomingCallScreen(
      {Key? key, required this.title, required this.timeduration})
      : super(key: key);

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Tween<double> _tween = Tween(begin: 0.75, end: 2);
  var userName = "";
  @override
  void initState() {
    super.initState();
    loadData();

    SystemSound.play(SystemSoundType.alert);
    Wakelock.enable();
    Vibration.vibrate(
        pattern: [500, 500, 500, 500, 500], intensities: [1, 255]);

    _controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _controller!.repeat(reverse: true);
  }

  final box = GetStorage();
  loadData() async {
    userName = box.read("username") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    List<String> splittitle = widget.title.split(',');
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Color.fromARGB(255, 7, 35, 58),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: _width / 3,
                left: _height / 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    userName == splittitle[0]
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("You have a Call with",
                                  style: GoogleFonts.lato(
                                      fontSize: 15, color: Colors.white)),
                              Text("${splittitle[1]}",
                                  style: GoogleFonts.lato(
                                      fontSize: 35, color: Colors.white)),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("You have a Call with",
                                  style: GoogleFonts.lato(
                                      fontSize: 15, color: Colors.white)),
                              Text("${splittitle[0]}",
                                  style: GoogleFonts.lato(
                                      fontSize: 35, color: Colors.white)),
                            ],
                          )
                  ],
                ),
              ),
              Positioned(
                child: Align(
                  child: ScaleTransition(
                    scale: _tween.animate(CurvedAnimation(
                        parent: _controller!, curve: Curves.elasticOut)),
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => VideoCallScreen(
                                professionalId: splittitle[0],
                                userid: splittitle[1],
                                timeduration: widget.timeduration,
                              ));
                        },
                        child: CircleAvatar(child: Icon(Icons.call)),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      side: BorderSide(
                                          color: Color.fromARGB(
                                              255, 0, 113, 205)))),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
