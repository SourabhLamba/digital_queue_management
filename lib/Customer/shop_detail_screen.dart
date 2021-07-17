import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CustomerInfoCrud.dart';
import '../widgets/show_toast.dart';

class ShopDetail extends StatefulWidget {
  final uid, name, phoneNo, photo, description, address;
  ShopDetail(
      {this.uid,
      this.name,
      this.address,
      this.description,
      this.photo,
      this.phoneNo});

  @override
  _ShopDetailState createState() =>
      _ShopDetailState(uid, name, phoneNo, photo, description, address);
}

class _ShopDetailState extends State<ShopDetail> {
  String uid, name, phoneNo, photo, description, address;
  _ShopDetailState(String uid, name, phoneNo, photo, description, address) {
    this.uid = uid;
    this.name = name;
    this.phoneNo = phoneNo;
    this.photo = photo;
    this.description = description;
    this.address = address;
  }

  var _sellersData;
  bool isLoading = true, isBooked = false, isLoading2 = true;
  List<String> timeLines;
  Map<int, String> book;
  Box<String> userId;
  String bookedTime;

  @override
  void initState() {
    userId = Hive.box<String>("userId");
    timeLines = [];
    book = Map<int, String>();
    timeLines.addAll({
      '7:00 am',
      '7:20 am',
      '7:40 am',
      '8:00 am',
      '8:20 am',
      '8:40 am',
      '9:00 am',
      '9:20 am',
      '9:40 am',
      '10:00 am',
      '10:20 am',
      '10:40 am',
      '11:00 am',
      '11:20 am',
      '11:40 am',
      '12:00 pm',
      '12:20 pm',
      '12:40 pm',
      '1:00 pm',
      '1:20 pm',
      '1:40 pm',
      '2:00 pm',
      '2:20 pm',
      '2:40 pm',
      '3:00 pm',
      '3:20 pm',
      '3:40 pm',
      '4:00 pm',
      '4:20 pm',
      '4:40 pm',
      '5:00 pm',
      '5:20 pm',
      '5:40 pm',
      '6:00 pm',
      '6:20 pm',
      '6:40 pm',
      '7:00 pm',
      '7:20 pm',
      '7:40 pm',
      '8:00 pm',
      '8:20 pm',
      '8:40 pm',
      '9:00 pm',
      '9:20 pm',
      '9:40 pm',
      '10:00 pm',
      '10:20 pm',
      '10:40 pm',
      '11:00 pm'
    });
    CustomerInfoCrud().getSellerTimeLine(uid).then((result) {
      setState(() {
        _sellersData = result;
        isLoading = false;
      });
    });

    CustomerInfoCrud().getBookedOrNot(uid).then((result) {
      for (int i = 0; i < timeLines.length; i++) {
        if (result.documents[0].data[i.toString()]
                .toString()
                .split('.')
                .first ==
            userId.getAt(0).toString()) {
          setState(() {
            bookedTime = result.documents[0].data[i.toString()]
                .toString()
                .split('.')
                .last;
            isBooked = true;
            isLoading2 = false;
          });
        }
      }
      setState(() {});
      isLoading2 = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading2 == false
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurpleAccent[400],
              title: Text("Shop Details"),
              centerTitle: true,
              elevation: 5,
            ),
            body: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height / 1.6,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 5,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                photo,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        customTile(Icons.business_rounded, name),
                        customTile(Icons.location_on, address),
                        customTile(Icons.details, description),
                        ListTile(
                          onTap: () {
                            _makePhoneCall("tel:$phoneNo", context);
                          },
                          dense: true,
                          leading: Icon(
                            Icons.call,
                            color: Colors.deepPurple[700],
                          ),
                          title: Text(phoneNo),
                        ),
                      ],
                    )),
                Expanded(
                  child: isBooked == false
                      ? sellerDetailStream()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Booked at",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  bookedTime,
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                  ),
                                )
                              ],
                            ),
                            button(
                              text: "Cancel",
                              onPressed: () {
                                isBooked = false;
                                CustomerInfoCrud()
                                    .deleteBooking(userId.getAt(0), name);

                                // CustomerInfoCrud()
                                //     .cancelUpdateOnSellerSide(uid, );
                                // setState(() {});
                              },
                            ),
                          ],
                        ),
                ),
              ],
            ),
          )
        : Scaffold(
            body: Center(
              child: SpinKitFadingCircle(
                color: Colors.purple[700],
              ),
            ),
          );
  }

  Widget sellerDetailStream() {
    return StreamBuilder(
        stream: _sellersData,
        builder: (context, snapShot) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 2.6,
                  crossAxisCount: 3,
                  mainAxisSpacing: MediaQuery.of(context).size.height / 50,
                  crossAxisSpacing: MediaQuery.of(context).size.width / 40,
                ),
                itemCount: timeLines.length,
                itemBuilder: (context, index) {
                  var snapData = snapShot
                      .data.documents[0].data[index.toString()]
                      .toString();

                  if (snapShot.data != null) {
                    if (snapData.split('.').first != "S" &&
                        snapData != "null") {
                      return gridButton(
                        text: timeLines[index],
                        color: Colors.purple[300],
                      );
                    } else if (snapData == "null") {
                      return gridButton(
                        text: timeLines[index],
                        color: Colors.red[300],
                      );
                    } else if (snapData.split('.').first == "S" ||
                        snapData != "null") {
                      String timeFrame = snapData.split('.').last;
                      return gridButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: ((builder) =>
                                  bottomSheet(timeFrame, index)));
                        },
                        text: timeFrame,
                        color: Colors.grey,
                      );
                    }
                  }
                  return SizedBox(
                    height: 0,
                    width: MediaQuery.of(context).size.width,
                  );
                }),
          );
        });
  }

  Widget bottomSheet(String time, int index) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Book at $time:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              button(
                text: 'Book',
                onPressed: () {
                  isBooked = true;
                  bookedTime = time;
                  String p = userId.getAt(0).toString() + "." + time;

                  CustomerInfoCrud().addbooking({
                    "name": name,
                    "photo": photo,
                    "time": time,
                  }, userId.getAt(0), name);

                  CustomerInfoCrud()
                      .bookingUpdateOnSellerSide(uid, {index.toString(): p});
                  Navigator.of(context).pop();
                  showToast("Booked");
                  setState(() {});
                },
              ),
              button(
                onPressed: () {
                  showToast("Canceled");
                  Navigator.of(context).pop();
                },
                text: "Cancel",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

customTile(IconData icon, String text) {
  return ListTile(
    dense: true,
    leading: Icon(
      icon,
      color: Colors.deepPurple[700],
    ),
    title: Text(text != null ? text : ''),
  );
}

button({Function onPressed, String text}) {
  return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red[500]),
        padding:
            MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(10)),
      ),
      child: Text(
        text != null ? text : '',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ));
}

gridButton({Color color, String text, Function onPressed}) {
  return ElevatedButton(
    style: ButtonStyle(
        elevation: MaterialStateProperty.all(4),
        backgroundColor: MaterialStateProperty.all<Color>(color)),
    onPressed: onPressed,
    child: Text(
      text != null ? text : '',
      style: TextStyle(fontSize: 14),
    ),
  );
}

Future<void> _makePhoneCall(String phoneNo, context) async {
  if (await canLaunch(phoneNo)) {
    await launch(
      phoneNo,
    );
  } else {
    showToast("Unable To Make The Call");
  }
}
