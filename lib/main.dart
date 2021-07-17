import 'dart:io';

import 'package:digi_queue/Customer/signup_customer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'Seller/home_screen_seller.dart';
import 'Customer/home_screen_customer.dart';
import 'select_user_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory documentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(documentDirectory.path);
  await Hive.openBox<String>("whoAreYou");
  await Hive.openBox<String>("userId");
  await Hive.openBox<bool>('isSwitched');
  runApp(MaterialApp(
    title: "Digi Q",
    theme: ThemeData.light(),
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    routes: {'CustomerSignUp': (context) => SignUpCustomer()},
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
            color: Colors.white,
            child: Center(
                child: Image.asset(
              'assets/images/logo.jpg',
              height: 100,
              width: 100,
            )),
          );
        }
        if (snapshot.data is FirebaseUser && snapshot.data != null) {
          if (whoAreYou.getAt(0).toString() == 'seller')
            return HomeScreenSeller();
          else if (whoAreYou.getAt(0).toString() == 'customer')
            return HomeScreenCustomer();
          else
            return SelectUserScreen();
        }
        return SelectUserScreen();
      },
    );
  }
}
