import 'package:digi_queue/Customer/after_lg_su/CustomerInfoCrud.dart';
import 'package:digi_queue/Customer/after_lg_su/Notification.dart';
import 'package:digi_queue/Customer/after_lg_su/Search.dart';
import 'package:digi_queue/Customer/after_lg_su/drawer.dart';
import 'package:digi_queue/Customer/after_lg_su/shopDetail.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

String _customerName, _customerPhoto, _customerEmail;
bool isLoading = true, _isLoading1 = true;
var _sellersData;
Box<String> userId;

class _HomeState extends State<Home> {
  @override
  void initState() {
    userId = Hive.box<String>("userId");
    super.initState();
    CustomerInfoCrud().getCustomer(userId.getAt(0)).then((result) {
      setState(() {
        _customerName = result['customerName'].toString();
        _customerPhoto = result['customerPhoto'].toString();
        _customerEmail = result['customerEmail'].toString();
        _isLoading1 = false;
      });
    });

    CustomerInfoCrud().getSellers().then((result) {
      setState(() {
        _sellersData = result;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading && !_isLoading1
        ? Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (builder) {
                  return Search();
                }));
              },
            ),
            drawer:
                drawer(context, _customerName, _customerEmail, _customerPhoto),
            appBar: AppBar(
              centerTitle: true,
              title: Text("Customer"),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (build) {
                      return NotificationBooks(_customerName, _customerPhoto);
                    }));
                  },
                  icon: Icon(Icons.notifications),
                ),
              ],
            ),
            body: _sellersStream(),
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget _sellersStream() {
    return StreamBuilder(
        stream: _sellersData,
        builder: (context, snapShot) {
          if (snapShot.data == null)
            return Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Loading Sellers",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );
          return ListView.builder(
              itemCount: snapShot.data.documents.length,
              itemBuilder: (build, index) {
                return FlatButton(
                  padding: EdgeInsets.fromLTRB(7.0, 5.0, 7.0, 5.0),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) {
                      return ShopDetail(
                          uid: snapShot.data.documents[index].data['userId']
                              .toString(),
                          name: snapShot.data.documents[index].data['shopName']
                              .toString(),
                          address: snapShot
                              .data.documents[index].data['shopAddress']
                              .toString(),
                          description: snapShot
                              .data.documents[index].data['shopDescription']
                              .toString(),
                          photo: snapShot
                              .data.documents[index].data['shopPhoto']
                              .toString(),
                          phoneNo: snapShot
                              .data.documents[index].data['shopPhoneNo']
                              .toString());
                    }));
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 2 * MediaQuery.of(context).size.height / 9,
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                            snapShot.data.documents[index].data['shopPhoto']
                                .toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          snapShot.data.documents[index].data['shopName']
                              .toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                        Text(snapShot.data.documents[index].data['shopAddress']
                            .toString()),
                        snapShot.data.documents[index].data['isOpen']
                                    .toString() ==
                                'true'
                            ? Text(
                                "Open",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                            : Text(
                                "Closed",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
