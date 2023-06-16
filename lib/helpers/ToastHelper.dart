import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  static void showToast(BuildContext context, String message) {
    FToast fToast = FToast();
    fToast.init(context);

    fToast.showToast(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.grey[900],
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
}
