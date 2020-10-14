import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomerDetail extends StatefulWidget {
  String userInfo;
  CustomerDetail({this.userInfo});

  @override
  _CustomerDetailState createState() => _CustomerDetailState(userInfo);
}

class _CustomerDetailState extends State<CustomerDetail> {
  String customerUid;
  _CustomerDetailState(String customerUid) {
    this.customerUid = customerUid;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Detail"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Text(customerUid),
        ),
      ),
    );
  }
}
