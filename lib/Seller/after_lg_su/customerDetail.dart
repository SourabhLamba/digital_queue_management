import 'package:digi_queue/Seller/after_lg_su/shopInfoCrud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        height: 200,
        child: Center(
          child: Image.asset(
            'assets/images/$data.jpg',
            height: 100,
            width: 100,
          ),
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
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: Colors.grey,
                            height: MediaQuery.of(context).size.width * 0.7,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: _result.data['customerPhoto'] == null //photo
                                ? Icon(
                                    Icons.account_box,
                                    size: 90,
                                    color: Colors.black,
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
                            leading: Icon(Icons.account_box_outlined,color: Colors.blue[900],),
                            title:Text(_result.data['customerName'],style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ), ),
                            //name
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            leading: Icon(Icons.phone,color: Colors.blue[900],),
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
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            leading: Icon(Icons.https,color: Colors.blue[900],),
                            title:Text(_result.data['userId'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                            )
                          )
                        ],
                      ),
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
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Unable to make a call"),
    ));
  }
}
