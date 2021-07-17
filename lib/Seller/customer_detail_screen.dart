import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:digi_queue/Seller/shopInfoCrud.dart';

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
  bool isReading = false;
  var _result;
  Box<String> userId;
  String barCodeResult;

  _CustomerDetailState(String customerUid) {
    this.customerUid = customerUid;
  }

  @override
  void initState() {
    userId = Hive.box<String>('userId');
    ShopInfoCrud().getCustomerInfo(userId.getAt(0), customerUid).then((result) {
      setState(() {
        _result = result;
        isLoading = false;
      });
    });
    super.initState();
  }

  Future scanBarCode() async {
    String _barCodeResult = await FlutterBarcodeScanner.scanBarcode(
        "#00008B", "Cancel", true, ScanMode.QR);
    setState(() {
      barCodeResult = _barCodeResult;
      if (barCodeResult == _result.data['userId']) {
        showModalBottomSheet(
            context: context, builder: ((builder) => bottomSheet("allowed")));
      } else {
        showModalBottomSheet(
            context: context,
            builder: ((builder) => bottomSheet("notAllowed")));
      }
    });
  }

  Widget bottomSheet(String data) {
    return Container(
        height: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/$data.jpg',
              height: 70,
              width: 70,
            ),
            SizedBox(
              height: 7,
            ),
            Text(data == 'allowed' ? 'Verified User' : 'Cannot Verify'),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return !isReading
        ? Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                scanBarCode();
              },
              icon: Icon(Icons.qr_code_scanner),
              label: Text("Scan"),
            ),
            appBar: AppBar(
              backgroundColor: Colors.blueAccent[700],
              title: Text("Customer Detail"),
              centerTitle: true,
            ),
            body: !isLoading
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.grey[250],
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          child: _result.data['customerPhoto'] == null //photo
                              ? Icon(
                                  Icons.image,
                                  size: 120,
                                  color: Colors.black38,
                                )
                              : Image(
                                  image: NetworkImage(
                                    _result.data['customerPhoto'],
                                  ),
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;

                                    return SpinKitThreeBounce(
                                      color: Colors.black38,
                                      size: 16,
                                    );
                                  },
                                ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          leading: Icon(
                            Icons.account_box_outlined,
                            color: Colors.blue[900],
                          ),
                          title: Text(
                            _result.data['customerName'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            leading: Icon(
                              Icons.phone,
                              color: Colors.blue[900],
                            ),
                            onTap: () {
                              _makePhoneCall(
                                  "tel:${_result.data['customerPhoneNo'].toString()}",
                                  context);
                            },
                            title: Text(
                              _result.data['customerPhoneNo'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                              ),
                            )), //phone
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          leading: Icon(
                            Icons.location_pin,
                            color: Colors.blue[900],
                          ),
                          title: Text(
                            _result.data['cutomerAddress'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: SpinKitFadingCircle(
                      color: Colors.blue[700],
                    ),
                  ),
          )
        : Scaffold(
            body: Center(
              child: SpinKitFadingCircle(
                color: Colors.blue[900],
              ),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Unable to make a call"),
    ));
  }
}
