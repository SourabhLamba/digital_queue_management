import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:digi_queue/Seller/initial/LoginPageS.dart';
import 'package:digi_queue/Seller/initial/SignPageS.dart';
import 'package:digi_queue/animation/FadeAnimation.dart';

class WelcomeS extends StatefulWidget {
  WelcomeS({Key key}) : super(key: key);

  @override
  _WelcomeSState createState() => _WelcomeSState();
}

class _WelcomeSState extends State<WelcomeS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Welcome \nSeller",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 40),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.2,
                      Align(
                        alignment:Alignment.topCenter,
                        child: Text(
                          "Queue Management",
                          style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700,color: Colors.blueAccent[400],),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              FadeAnimation(
                  1.4,
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Lottie.asset('assets/lottie/social_distancing.json'),
                  )),
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1.5,
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 50,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPageS()));
                        },
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.6,
                      Container(
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
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupPageS()));
                          },
                          color: Colors.blueAccent[700],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
