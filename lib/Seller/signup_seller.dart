import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'account_seller.dart';
import 'shopInfoCrud.dart';
import '../animation/FadeAnimation.dart';
import 'login_seller.dart';
import '../widgets/blue_custom_button.dart';
import '../widgets/show_toast.dart';

class SignUpSeller extends StatefulWidget {
  @override
  _SignUpSellerState createState() => _SignUpSellerState();
}

class _SignUpSellerState extends State<SignUpSeller> {
  String _email = '', _password1 = "", _password2 = "";

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    FadeAnimation(
                        1,
                        Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                        1.2,
                        Text(
                          "Create an account, It's free",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
                        )),
                  ],
                ),
                Column(
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
                            _password1 = value;
                          },
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                        1.4,
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.https),
                              border: OutlineInputBorder(),
                              labelText: "Confirm Password"),
                          onChanged: (value) {
                            _password2 = value;
                          },
                        )),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                FadeAnimation(
                  1.5,
                  BlueCustomButton(
                    labelText: "Sign Up",
                    onPressed: () {
                      if (_password1 != _password2) {
                        showToast("Passwords do not match.");
                      } else {
                        setState(() => isLoading = true);
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _email, password: _password1)
                            .then((value) {
                          whoAreYou.putAt(0, "seller");
                          userId.putAt(0, value.user.uid.toString());
                          var shopData = {
                            "userId": value.user.uid,
                            "shopEmail": _email,
                            "type": "seller",
                            'isOpen': false
                          };
                          ShopInfoCrud().createShop(value.user.uid, shopData);
                          if (value.user != null) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return AccountSeller();
                            }));
                          }
                        }).catchError((e) {
                          showToast(e.message.toString());
                          setState(() => isLoading = false);
                        });
                      }
                    },
                  ),
                ),
                FadeAnimation(
                    1.6,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginSeller()));
                          },
                          child: Text(
                            "Login",
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
      ),
    );
  }
}
