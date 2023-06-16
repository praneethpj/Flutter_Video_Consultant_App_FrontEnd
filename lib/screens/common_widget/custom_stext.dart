import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextWidgetTitle extends StatefulWidget {
  final String text;
  final double size;

  const CustomTextWidgetTitle({
    super.key,
    required this.text,
    required this.size,
  });

  @override
  State<CustomTextWidgetTitle> createState() => _CustomTextWidgetState();
}

class _CustomTextWidgetState extends State<CustomTextWidgetTitle> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(166, 66, 170, 255),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    topLeft: Radius.circular(20))),
            width: 40,
            height: 20,
            child: Center(
              child: Text("${widget.text} \$",
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: widget.size,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
