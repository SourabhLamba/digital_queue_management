import 'package:digi_queue/Seller/after_lg_su/shopInfoCrud.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class CustomerDetail extends StatefulWidget {
  String userInfo;
  CustomerDetail({this.userInfo});

  @override
  _CustomerDetailState createState() => _CustomerDetailState(userInfo);
}

class _CustomerDetailState extends State<CustomerDetail> {
  String customerUid;
  bool isLoading = true;
  var _result;
  Box<String> userId;

  _CustomerDetailState(String customerUid) {
    this.customerUid = customerUid;
  }

  @override
  void initState() {
    userId = Hive.box<String>('userId');
    ShopInfoCrud().getCustomerInfo(userId.getAt(0), customerUid).then((result) {
      setState(() {
        _result = result;
        //print(_result.data['customerName']);
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Detail"),
        centerTitle: true,
      ),
      body: !isLoading
          ? Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.grey,
                      height: MediaQuery.of(context).size.height / 5,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: _result.data['customerPhoto'] == null //photo
                          ? Icon(
                              Icons.account_box,
                              size: 90,
                              color: Colors.black,
                            )
                          : Image(
                              image: NetworkImage(
                                _result.data['customerPhoto'],
                              ), //photo
                            ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      _result.data['customerName'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ), //name
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                        onPressed: () {
                          _makePhoneCall(
                              "tel:${_result.data['customerPhoneNo'].toString()}",
                              context);
                        },
                        child: Text(
                          _result.data['customerPhoneNo'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        )), //phone
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      _result.data['userId'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

Future<void> _makePhoneCall(String phoneNo, context) async {
  if (await canLaunch(phoneNo)) {
    await launch(
      phoneNo,
    );
  } else {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Unable to make a call"),
    ));
  }
}
