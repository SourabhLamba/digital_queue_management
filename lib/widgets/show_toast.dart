import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String message) {
  Fluttertoast.showToast(
    fontSize: 14,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
  );
}
