import 'package:digi_queue/Seller/home_screen_seller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../animation/FadeAnimation.dart';
import 'signup_seller.dart';
import '../widgets/blue_custom_button.dart';
import '../widgets/show_toast.dart';

class LoginSeller extends StatefulWidget {
  @override
  _LoginSellerState createState() => _LoginSellerState();
}

class _LoginSellerState extends State<LoginSeller> {
  String _email = "", _password = "";
  Box<String> whoAreYou;
  Box<String> userId;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    whoAreYou = Hive.box<String>("whoAreYou");
    userId = Hive.box<String>('userId');
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      opacity: 0.6,
      inAsyncCall: isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.2,
                      Text(
                        "Login to your account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: <Widget>[
                    FadeAnimation(
                        1.2,
                        TextField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                              labelText: "Email"),
                          onChanged: (value) {
                            _email = value;
                          },
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                        1.3,
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                              labelText: "Password"),
                          onChanged: (value) {
                            _password = value;
                          },
                        )),
                  ],
                ),
              ),
              FadeAnimation(
                  1.4,
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: BlueCustomButton(
                        labelText: "Login",
                        onPressed: () {
                          if (_email == "" || _password == "") {
                            showToast("Credentials Empty");
                          } else {
                            setState(() => isLoading = true);
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: _email,
                              password: _password,
                            )
                                .then((value) {
                              whoAreYou.putAt(0, "seller");
                              userId.putAt(0, value.user.uid.toString());
                              if (value.user != null) {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return HomeScreenSeller();
                                    },
                                  ),
                                );
                              } else {
                                showToast("User not created.");
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }).catchError(
                              (e) {
                                showToast(e.message.toString());
                                setState(
                                  () {
                                    isLoading = false;
                                  },
                                );
                              },
                            );
                          }
                        },
                      ))),
              FadeAnimation(
                  1.5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SignUpSeller();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.blueAccent[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
