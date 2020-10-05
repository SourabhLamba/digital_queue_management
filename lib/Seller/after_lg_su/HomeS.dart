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
  bool isLoading = true;
  var timeLineData;
  List<String> timeInterval;

  @override
  void initState() {
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
            // for (int i = 0; i < timeInterval.length; i++) {
            //   if (result[i.toString()].toString() != "null")
            //     print(result[i.toString()].toString());
            // }
            setState(() {
              timeLineData = result;
            });
          });
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return isLoading == false
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
                if (snapShot.data.documents[0].data[index.toString()]
                        .toString() !=
                    'null') {
                  String s1 = snapShot.data.documents[0].data[index.toString()]
                      .toString()
                      .split('.')
                      .first;
                  String s2 = snapShot.data.documents[0].data[index.toString()]
                      .toString()
                      .split('.')
                      .last;
                  return ListTile(
                    title: Text(s1),
                    subtitle: Text(s2),
                  );
                } else
                  return ListTile(
                    title: Text(''),
                    subtitle: Text(''),
                  );
              });
        });
  }
}
