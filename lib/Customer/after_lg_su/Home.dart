import 'package:digi_queue/Customer/after_lg_su/CustomerInfoCrud.dart';
import 'package:digi_queue/Customer/after_lg_su/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:digi_queue/main.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

String _customerName, _customerPhoto, _customerEmail;
bool isLoading = true;

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    CustomerInfoCrud().getCustomer(userId.getAt(0)).then((result) {
      setState(() {
        _customerName = result['customerName'].toString();
        _customerPhoto = result['customerPhoto'].toString();
        _customerEmail = result['customerEmail'].toString();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Scaffold(
            drawer:
                drawer(context, _customerName, _customerEmail, _customerPhoto),
            appBar: AppBar(
              centerTitle: true,
              title: Text("Customer"),
            ),
            body: Container(
              child: Center(),
            ),
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
