import 'package:flutter/material.dart';

class BlueCustomButton extends StatelessWidget {
  final Function onPressed;
  final String labelText;

  BlueCustomButton({this.onPressed, this.labelText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 3, left: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border(
            bottom: BorderSide(color: Colors.black),
            top: BorderSide(color: Colors.black),
            left: BorderSide(color: Colors.black),
            right: BorderSide(color: Colors.black),
          )),
      child: MaterialButton(
        minWidth: double.infinity,
        height: 50,
        color: Colors.blueAccent[700],
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Text(
          labelText,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
