import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LableWidget extends StatefulWidget {
  String title;
  IconData icons;

  LableWidget({super.key, required this.title, required this.icons});

  @override
  State<LableWidget> createState() => _LableWidgetState();
}

class _LableWidgetState extends State<LableWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Center(
                    child: Icon(
                      widget.icons,
                      color: Color.fromARGB(255, 135, 151, 255),
                    ),
                  ),
                ),
                Container(
                  width: width * 0.70,
                  height: 50,
                  color: Color.fromARGB(255, 253, 253, 253),
                  child: Center(
                      child: Text(
                    widget.title,
                    style: GoogleFonts.lato(fontSize: 20),
                  )),
                ),
                Container(
                  width: width * 0.10,
                  height: 50,
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Center(
                      child: Icon(
                    Icons.arrow_forward,
                    color: Color.fromARGB(255, 135, 151, 255),
                  )),
                )
              ],
            ),
            Divider(
              color: Color.fromARGB(255, 184, 184, 184),
              height: 36,
            )
          ],
        ),
      ),
    );
  }
}
