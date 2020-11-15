import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:digi_queue/Seller/after_lg_su/HomeS.dart';
import 'package:digi_queue/Seller/after_lg_su/shopInfoCrud.dart';
import 'package:digi_queue/animation/FadeAnimation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'LoginPageS.dart';

class SignupPageS extends StatefulWidget {
  @override
  _SignupPageSState createState() => _SignupPageSState();
}

class _SignupPageSState extends State<SignupPageS> {
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
    return isLoading == true
        ? AlertDialog(
            title: Center(
              child: Text("Loading"),
            ),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width / 6,
              child: Center(
                child: SpinKitWave(
                  color: Colors.blue[900],
                ),
              ),
            ),
          )
        : Scaffold(
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
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[700]),
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
                              if (_email == '' ||
                                  _password1 == '' ||
                                  _password2 == '') {
                                Fluttertoast.showToast(
                                  msg: "Credentials Empty",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                );
                              } else if (_password1 != _password2) {
                                Fluttertoast.showToast(
                                    msg: "Password Mismatch",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER);
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

                                  ShopInfoCrud()
                                      .createShop(value.user.uid, shopData);
                                  if (value.user != null) {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return HomeS();
                                    }));
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "User Not Created",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                    );
                                    setState(() => isLoading = false);
                                  }
                                }).catchError((e) {
                                  Fluttertoast.showToast(
                                    msg: e.message.toString(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                                  setState(() => isLoading = false);
                                });
                              }
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
                        )),
                    FadeAnimation(
                        1.6,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Already have an account?"),
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPageS()));
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
          );
  }

  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
