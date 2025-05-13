import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Displays a customizable toast notification at the top of the screen.
///
/// [message] is required. Optional [backgroundColor] and [textColor] default to blue and white.
void showToast({
  required String message,
  Color backgroundColor = Colors.blue,
  Color textColor = Colors.white,
}) {
  Fluttertoast.showToast(
    msg: message, 
    toastLength: Toast.LENGTH_SHORT, 
    gravity: ToastGravity.TOP, 
    timeInSecForIosWeb: 1, 
    backgroundColor: backgroundColor, 
    textColor: textColor,
    fontSize: 16.0 
  );
}
