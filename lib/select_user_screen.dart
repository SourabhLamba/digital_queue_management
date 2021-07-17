import 'package:flutter/material.dart';

import 'welcome_screen.dart';
import 'animation/FadeAnimation.dart';

class SelectUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(30, 20, 30, 50),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FadeAnimation(
                  1,
                  Text(
                    "Welcome",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FadeAnimation(
                  1.2,
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return WelcomeScreen('Seller');
                        }),
                      );
                    },
                    child: Image.asset(
                      'assets/images/seller.jpg',
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.height / 4,
                    ),
                  ),
                ),
                FadeAnimation(
                  1.3,
                  Text(
                    "Seller",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FadeAnimation(
                  1.4,
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return WelcomeScreen('Customer');
                      }),
                    ),
                    child: Image.asset(
                      'assets/images/customer.jpg',
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.height / 4,
                    ),
                  ),
                ),
                FadeAnimation(
                  1.5,
                  Text(
                    "Customer",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
              ]),
        ),
      )),
    );
  }
}
