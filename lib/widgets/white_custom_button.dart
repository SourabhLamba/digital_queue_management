import 'package:flutter/material.dart';

class WhiteCustomButton extends StatelessWidget {
  final Function onPressed;

  WhiteCustomButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      height: 50,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(50)),
      child: Text(
        "Login",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
    );
  }
}
