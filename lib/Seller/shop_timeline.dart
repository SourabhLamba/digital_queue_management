import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

import 'package:digi_queue/Seller/home_screen_seller.dart';
import 'package:digi_queue/Seller/shopInfoCrud.dart';
import '../main.dart';

class TimeLineS extends StatefulWidget {
  @override
  _TimeLineSState createState() => _TimeLineSState();
}

class _TimeLineSState extends State<TimeLineS> {
  Box<bool> isSwitched;
  Map<String, String> timeLine;
  List<String> timeSelected;
  bool _isOpen;
  bool _isLoading;

  @override
  void initState() {
    timeLine = {};
    timeSelected = [];
    timeSelected.addAll({
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
    isSwitched = Hive.box<bool>('isSwitched');
    _isLoading = true;
    getOpenStatus();
    super.initState();
  }

  getOpenStatus() {
    ShopInfoCrud().getShop(userId.getAt(0)).then((result) {
      setState(() {
        _isOpen = result['isOpen'];
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading == false
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueAccent[700],
              centerTitle: true,
              title: Text("Time Line"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (builder) {
                      return HomeScreenSeller();
                    }));
                  },
                ),
                Switch(
                  value: _isOpen,
                  onChanged: (value) {
                    ShopInfoCrud()
                        .upDateShopData(userId.getAt(0), {'isOpen': value});
                    if (value == true) {
                      ShopInfoCrud().createTimeLines(userId.getAt(0), timeLine);
                      setState(() {
                        _isOpen = value;
                        Fluttertoast.showToast(
                          msg: 'Shop Opened',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                        );
                      });
                    } else {
                      ShopInfoCrud()
                          .createTimeLines(userId.getAt(0), {"1": "CLOSE"});
                      setState(() {
                        timeLine.clear();
                        _isOpen = value;
                        Fluttertoast.showToast(
                            msg: 'Shop Closed',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.SNACKBAR);
                      });
                    }
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ],
            ),
            body: Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: _isOpen == false
                  ? grids()
                  : Center(
                      child: Image.asset(
                        'assets/images/open.jpg',
                        height: MediaQuery.of(context).size.width / 2,
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                    ),
            ))
        : Scaffold(
            body: Center(
              child: SpinKitFadingCircle(
                color: Colors.blue[900],
              ),
            ),
          );
  }

  Widget grids() {
    return GridView.count(
      padding: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 10.0,
      ),
      childAspectRatio: 3,
      mainAxisSpacing: MediaQuery.of(context).size.height / 40,
      crossAxisSpacing: MediaQuery.of(context).size.width / 30,
      crossAxisCount: 3,
      children: List.generate(timeSelected.length, (index) {
        return timeSelected[index].contains('S')
            ? ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(14),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.greenAccent)),
                child: Text(
                  "Selected",
                  style: TextStyle(fontSize: 14),
                ),
                onPressed: () {
                  setState(() {
                    String s = timeSelected[index].split('.').last;
                    timeSelected.removeAt(index);
                    timeSelected.insert(index, s);
                    timeLine.remove(index.toString());
                  });
                })
            : ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(14),
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                onPressed: () {
                  setState(() {
                    String s = timeSelected[index];
                    timeSelected.removeAt(index);
                    timeSelected.insert(index, 'S.$s');
                    timeLine[index.toString()] = timeSelected[index].toString();
                    // print(timeLine);
                  });
                },
                child: Text(
                  timeSelected[index],
                  style: TextStyle(fontSize: 14),
                ),
              );
      }),
    );
  }
}
