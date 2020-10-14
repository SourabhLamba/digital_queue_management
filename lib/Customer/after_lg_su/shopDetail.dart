import 'package:digi_queue/Customer/after_lg_su/CustomerInfoCrud.dart';
import 'package:flutter/material.dart';

class ShopDetail extends StatefulWidget {
  String uid;
  ShopDetail({this.uid});

  @override
  _ShopDetailState createState() => _ShopDetailState(uid);
}

class _ShopDetailState extends State<ShopDetail> {
  String uid;
  _ShopDetailState(String uid) {
    this.uid = uid;
  }

  var _sellersData;
  bool isLoading = true;
  List<String> timeLines;

  @override
  void initState() {
    timeLines.addAll({
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
    CustomerInfoCrud().getSellerTimeLine(uid).then((result) {
      setState(() {
        _sellersData = result;
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == false
        ? Scaffold(
            appBar: AppBar(
              title: Text("Shop Details"),
              centerTitle: true,
            ),
            body: Container(
              child: sellerDetailStream(),
            ),
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget sellerDetailStream() {
    return StreamBuilder(
        stream: _sellersData,
        builder: (context, snapShot) {
          return GridView.builder(
            itemCount: timeLines.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              if (snapShot.data.documents[0].data[index].toString() != 'null')
                return Container(
                  color: Colors.green,
                  child: Center(
                    child:
                        Text(snapShot.data.documents[0].data[index].toString()),
                  ),
                );
              else
                return Container(
                    color: Colors.red,
                    child: Center(
                      child: Text(_sellersData[index]),
                    ));
            },
          );
        });
  }
}
