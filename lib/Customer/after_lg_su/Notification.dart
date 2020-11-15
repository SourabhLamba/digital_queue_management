import 'package:digi_queue/Customer/after_lg_su/CustomerInfoCrud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:qr_flutter/qr_flutter.dart';

class NotificationBooks extends StatefulWidget {
  final customerName, customerPhoto;

  NotificationBooks({this.customerName, this.customerPhoto});
  @override
  _NotificationBooksState createState() =>
      _NotificationBooksState(customerName, customerPhoto);
}

//Box<List<String>> shopBookedList;
Box<String> userId;
bool isLoading = true;
var data;

class _NotificationBooksState extends State<NotificationBooks> {
  String customerName, customerPhoto;
  _NotificationBooksState(String _customerName, String _customerPhoto) {
    this.customerName = _customerName;
    this.customerPhoto = _customerPhoto;
  }
  @override
  void initState() {
    //shopBookedList = Hive.box<List<String>>('shopBookedDetail');
    userId = Hive.box<String>("userId");
    super.initState();

    CustomerInfoCrud().getBookings(userId.getAt(0)).then((result) {
      setState(() {
        data = result;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: Text("Notification"),
      ),
      body: isLoading
          ? Center(
              child: Center(
                child: SpinKitFadingCircle(
                  color: Colors.deepPurple[700],
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(data.documents[index].data['name']),
                    onDismissed: (direction) {
                      CustomerInfoCrud().deleteBooking(
                          userId.getAt(0), data.documents[index].data['name']);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Deleted"),
                      ));
                    },
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.receipt,
                        color: Colors.deepPurpleAccent[900],
                      ),
                      title: Text(
                        data.documents[index].data['name'],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        data.documents[index].data['time'],
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialog(
                                customerName: customerName,
                                customerPhoto: customerPhoto,
                                time: data.documents[index].data['time'],
                                shopName: data.documents[index].data['name'],
                                customerUid: userId.getAt(0)));
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String customerName, customerPhoto, time, shopName, customerUid;
  CustomDialog(
      {this.customerName,
      this.customerPhoto,
      this.time,
      this.shopName,
      this.customerUid});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  customerName,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  shopName,
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Text(
                  customerUid,
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Text(
                  time,
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w900,
                      fontSize: 18),
                ),
                QrImage(
                  data: customerUid,
                  version: QrVersions.auto,
                  size: 200,
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            child:Center(
              child: customerPhoto == null
                  ? CircleAvatar(
                backgroundColor: Colors.deepPurple[700],
                radius: 50,
              )
                  : CircleAvatar(
                backgroundImage: NetworkImage(customerPhoto),
                radius: 50,
                backgroundColor: Colors.deepPurple[700],
              ),
            )
          ),
        ],
      ),
    );
  }
}
