import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:digi_queue/Seller/after_lg_su/HomeS.dart';
import 'Customer/Welcome.dart';
import 'Customer/after_lg_su/Home.dart';
import 'Seller/WelcomeS.dart';
import 'animation/FadeAnimation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox<String>("whoAreYou");
  await Hive.openBox<String>("userId");
  await Hive.openBox<bool>('isSwitched');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

Box<String> whoAreYou;
Box<String> userId;
Box<bool> isSwitched;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    whoAreYou = Hive.box<String>("whoAreYou");
    userId = Hive.box<String>('userId');
    isSwitched = Hive.box<bool>('isSwitched');
    if (whoAreYou.isEmpty) whoAreYou.put(0, "0");
    if (userId.isEmpty) userId.put(0, "0");
    if (isSwitched.isEmpty) isSwitched.put(0, false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Lottie.asset('assets/lottie/social_distancing.json'),
            ),
          );
        }
        if (snapshot.data is FirebaseUser && snapshot.data != null) {
          if (whoAreYou.getAt(0).toString() == 'seller')
            return HomeS();
          else if (whoAreYou.getAt(0).toString() == 'customer')
            return Home();
          else
            return HPage();
        }
        return HPage();
      },
    );
  }
}

class HPage extends StatelessWidget {
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
          children: [
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
            FlatButton(
              color: Colors.yellow,
              child: Text("Seller"),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return WelcomeS();
                }),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              color: Colors.tealAccent,
              child: Text("Customer"),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return Welcome();
                }),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
