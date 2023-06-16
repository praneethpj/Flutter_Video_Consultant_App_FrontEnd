import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetalk/models/payment.dart';

enum GradientButtonType {
  CALLBUTTON,
  PAYMENTBUTTON,
  SUCCESS,
  WARNING,
  HALT,
  DISABLE
}

class GradientButton extends StatelessWidget {
  String title;
  GradientButtonType type;
  VoidCallback function;
  GradientButton(
      {super.key,
      required this.title,
      required this.type,
      required this.function});

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    if (type == GradientButtonType.CALLBUTTON) {
      return SizedBox(
        width: _size.width * 0.65,
        child: DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.blueAccent,
                  Color.fromARGB(255, 255, 82, 246),
                  Color.fromARGB(255, 126, 64, 251)
                  //add more colors
                ]),
                borderRadius: BorderRadius.circular(5),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                      blurRadius: 5) //blur radius of shadow
                ]),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onSurface: Colors.transparent,
                  shadowColor: Colors.transparent,
                  //make color or elevated button transparent
                ),
                onPressed: function,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 18,
                    bottom: 18,
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.lato(fontSize: 16),
                  ),
                ))),
      );
    } else if (type == GradientButtonType.PAYMENTBUTTON) {
      return SizedBox(
        width: _size.width * 0.45,
        child: DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.blueAccent,
                  Color.fromARGB(255, 166, 82, 255),
                  Color.fromARGB(255, 176, 64, 251)
                  //add more colors
                ]),
                borderRadius: BorderRadius.circular(5),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                      blurRadius: 5) //blur radius of shadow
                ]),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onSurface: Colors.transparent,
                  shadowColor: Colors.transparent,
                  //make color or elevated button transparent
                ),
                onPressed: function,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 18,
                    bottom: 18,
                  ),
                  child: Text(title),
                ))),
      );
    } else if (type == GradientButtonType.DISABLE) {
      return SizedBox(
          width: _size.width * 0.45,
          child: ElevatedButton(
              onPressed: null,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 18,
                  bottom: 18,
                ),
                child: Text(title),
              )));
    } else {
      return SizedBox(
        width: _size.width * 0.5,
        child: DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.blueAccent,
                  Color.fromARGB(255, 166, 82, 255),
                  Color.fromARGB(255, 176, 64, 251)
                  //add more colors
                ]),
                borderRadius: BorderRadius.circular(5),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                      blurRadius: 5) //blur radius of shadow
                ]),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onSurface: Colors.transparent,
                  shadowColor: Colors.transparent,
                  //make color or elevated button transparent
                ),
                onPressed: function,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 18,
                    bottom: 18,
                  ),
                  child: Text(title),
                ))),
      );
    }
  }
}
