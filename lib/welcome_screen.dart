import 'package:digi_queue/Customer/login_customer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'Seller/login_seller.dart';
import 'Seller/signup_seller.dart';
import 'animation/FadeAnimation.dart';
import 'widgets/white_custom_button.dart';
import 'widgets/blue_custom_button.dart';
import 'Customer/signup_customer.dart';

class WelcomeScreen extends StatefulWidget {
  final String whoIsIt;
  WelcomeScreen(this.whoIsIt);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FadeAnimation(
                        1,
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Welcome \n${widget.whoIsIt}",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 40,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                        1.2,
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Queue Management",
                            style: TextStyle(
                              //fontStyle: ,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueAccent[400],
                            ),
                          ),
                        )),
                  ],
                ),
                FadeAnimation(
                    1.4,
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      child:
                          Lottie.asset('assets/lottie/social_distancing.json'),
                    )),
                Column(
                  children: <Widget>[
                    FadeAnimation(
                      1.5,
                      WhiteCustomButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => widget.whoIsIt == 'Seller'
                                    ? LoginSeller()
                                    : LoginCustomer(),
                              ));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                        1.6,
                        BlueCustomButton(
                          labelText: "Sign Up",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      widget.whoIsIt == 'Seller'
                                          ? SignUpSeller()
                                          : SignUpCustomer(),
                                ));
                          },
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
