import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinKitWaveLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          "Loading",
        ),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height / 6,
        width: MediaQuery.of(context).size.width / 6,
        child: Center(
          child: SpinKitWave(
            color: Colors.deepPurple[700],
          ),
        ),
      ),
    );
  }
}
