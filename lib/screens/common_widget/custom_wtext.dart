import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextWidget extends StatefulWidget {
  final String text;
  final double size;
  const CustomTextWidget({super.key, required this.text, required this.size});

  @override
  State<CustomTextWidget> createState() => _CustomTextWidgetState();
}

class _CustomTextWidgetState extends State<CustomTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        child: Text(widget.text,
            style: GoogleFonts.breeSerif(
                fontWeight: FontWeight.bold, fontSize: widget.size)),
      ),
    );
  }
}
