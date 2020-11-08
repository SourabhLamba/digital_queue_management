import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NotificationBooks extends StatefulWidget {
  String _customerName, _customerPhoto;

  NotificationBooks(String _customerName, String _customerPhoto) {
    this._customerName = _customerName;
    this._customerPhoto = _customerPhoto;
  }
  @override
  _NotificationBooksState createState() =>
      _NotificationBooksState(_customerName, _customerPhoto);
}

Box<List<String>> shopBookedList;
Box<String> userId;

class _NotificationBooksState extends State<NotificationBooks> {
  String customerName, customerPhoto;
  _NotificationBooksState(String _customerName, String _customerPhoto) {
    this.customerName = _customerName;
    this.customerPhoto = _customerPhoto;
  }
  @override
  void initState() {
    shopBookedList = Hive.box<List<String>>('shopBookedDetail');
    userId = Hive.box<String>("userId");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Notification"),
      ),
      body: shopBookedList.isEmpty
          ? Center(
              child: Text(
                "EMPTY",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: shopBookedList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(shopBookedList.getAt(index)[0]),
                    onDismissed: (direction) {
                      setState(() {
                        shopBookedList.deleteAt(index);
                      });
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Deleted"),
                      ));
                    },
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.shopping_basket,
                        color: Colors.blue[900],
                      ),
                      title: Text(
                        shopBookedList.getAt(index)[0],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        shopBookedList.getAt(index)[2],
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialog(
                                customerName: customerName,
                                customerPhoto: customerPhoto,
                                time: shopBookedList.getAt(index)[2],
                                shopName: shopBookedList.getAt(index)[0],
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
                  offset: Offset(0.0, 10.0),
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
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    time,
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w900,
                        fontSize: 16),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            child: CircleAvatar(
              backgroundImage: NetworkImage(customerPhoto),
              radius: 50.0,
            ),
          ),
        ],
      ),
    );
  }
}
