import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Used for showing snack bars
class ToastMessage {
  static void showSuccess(String message) {
    _show(message);
  }

  static void showError(String message) {
    _show(message, color: Colors.red);
  }

  static void _show(String message, {var color = Colors.black}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[200],
      textColor: color,
      fontSize: 16.0,
    );
  }
}
