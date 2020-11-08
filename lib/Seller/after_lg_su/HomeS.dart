import 'package:digi_queue/Seller/after_lg_su/customerDetail.dart';
import 'package:flutter/material.dart';
import 'package:digi_queue/Seller/after_lg_su/DrawerS.dart';
import 'package:digi_queue/Seller/after_lg_su/shopInfoCrud.dart';
import 'package:digi_queue/main.dart';

class HomeS extends StatefulWidget {
  @override
  _HomeSState createState() => _HomeSState();
}

class _HomeSState extends State<HomeS> {
  String _shopName, _shopPhoto;
  bool _isOpen;
  bool isLoading;
  var timeLineData;
  List<String> timeInterval;
  var _tileColor = Colors.grey[300];

  @override
  void initState() {
    isLoading = true;
    super.initState();
    timeInterval = List<String>();
    timeInterval.addAll({
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
    });
    //Getting Shop Information

    ShopInfoCrud().getShop(userId.getAt(0)).then((result) {
      setState(() {
        _shopName = result['shopName'].toString();
        _shopPhoto = result['shopPhoto'].toString();
        _isOpen = result['isOpen'];
        isLoading = false;
      });
      if (_isOpen) {
        setState(() {
          ShopInfoCrud().getTimeLIne(userId.getAt(0)).then((result) {
            setState(() {
              timeLineData = result;
            });
          });
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return !isLoading
        ? Scaffold(
            drawer: drawerS(context, _shopName, "", _shopPhoto),
            appBar: AppBar(
              centerTitle: true,
              title: Text("SELLER"),
            ),
            body: _isOpen
                ? Container(
                    child: _customerStream(),
                  )
                : Center(
                    child: Text("Shop is Close"),
                  ),
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget _customerStream() {
    return StreamBuilder(
        stream: timeLineData,
        builder: (context, snapShot) {
          return ListView.builder(
              itemCount: timeInterval.length,
              itemBuilder: (context, index) {
                if (snapShot.data != null) {
                  if (snapShot.data.documents[0].data[index.toString()] !=
                      null) {
                    String userInfo = snapShot
                        .data.documents[0].data[index.toString()]
                        .toString()
                        .split('.')
                        .first;
                    if (userInfo == 'S') userInfo = 'Not booked yet';

                    String timeFrame = snapShot
                        .data.documents[0].data[index.toString()]
                        .toString()
                        .split('.')
                        .last;
                    return Container(
                      padding: EdgeInsets.fromLTRB(7.0, 5.0, 7.0, 5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: ListTile(
                        onTap: () {
                          if (userInfo == 'Not booked yet') {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(userInfo),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) =>
                                    CustomerDetail(userInfo: userInfo),
                              ),
                            );
                          }
                        },
                        tileColor: userInfo == 'Not booked yet'
                            ? _tileColor
                            : Colors.greenAccent,
                        dense: true,
                        title: Text(
                          userInfo,
                        ),
                        subtitle: Text(
                          timeFrame,
                        ),
                        leading: Icon(
                          Icons.account_circle,
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.fromLTRB(7.0, 5.0, 7.0, 5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: ListTile(
                          dense: true,
                          leading: Icon(Icons.close),
                          tileColor: Colors.red[300],
                          title: Text(timeInterval[index])),
                    );
                  }
                }
              });
        });
  }
}
