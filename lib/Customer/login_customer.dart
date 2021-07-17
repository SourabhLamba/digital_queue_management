import 'package:digi_queue/widgets/blue_custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'home_screen_customer.dart';
import '../animation/FadeAnimation.dart';
import 'signup_customer.dart';

class LoginCustomer extends StatefulWidget {
  static const routeName = '/LoginPage';
  @override
  _LoginCustomerState createState() => _LoginCustomerState();
}

class _LoginCustomerState extends State<LoginCustomer> {
  String _email = "", _password = "";
  Box<String> whoAreYou;
  Box<String> userId;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    whoAreYou = Hive.box<String>("whoAreYou");
    userId = Hive.box<String>("userId");
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      opacity: 0.6,
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
                            Fluttertoast.showToast(
                                msg: "Credentials Empty",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER);
                          } else {
                            setState(() => isLoading = true);
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: _email, password: _password)
                                .then((value) {
                              whoAreYou.putAt(0, "customer");
                              userId.putAt(0, value.user.uid.toString());
                              if (value.user != null) {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return HomeScreenCustomer();
                                    },
                                  ),
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: "User Not Created",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                );
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }).catchError(
                              (e) {
                                Fluttertoast.showToast(
                                  msg: e.message.toString(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                );
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
                    //crossAxisAlignment: CrossAxisAlignment.baseline,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                              context, SignUpCustomer.routeName);
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
